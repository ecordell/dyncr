package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/load"
	"github.com/cuebernetes/cuebectl/pkg/apply"
	"github.com/cuebernetes/cuebectl/pkg/controller"
	cuedelete "github.com/cuebernetes/cuebectl/pkg/delete"
	flag "github.com/spf13/pflag"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/client-go/dynamic"
	cmdutil "k8s.io/kubectl/pkg/cmd/util"

	"github.com/ecordell/dyncr/imgbuild"
	"github.com/ecordell/dyncr/provision"
	"github.com/ecordell/dyncr/runbin"
)

var cleanup = flag.Bool("cleanup", true, "if true, cleans up resources when process is killed")
var cleanupCluster = flag.Bool("cleanup-cluster", true, "if true, cleans up cluster when process is killed")

func main() {
	flags := genericclioptions.NewConfigFlags(true)
	// TODO: klog, kubeconfig
	//globalflag.AddGlobalFlags(flag.CommandLine, "provisioner")
	flag.Parse()

	f := cmdutil.NewFactory(flags)

	kubeconfig := f.ToRawKubeConfigLoader().ConfigAccess().GetExplicitFile()
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM, syscall.SIGKILL, syscall.SIGSTOP)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	r := cue.Runtime{}
	is := load.Instances([]string{"."}, &load.Config{
		Dir: "./manifests",
	})
	if len(is) > 1 {
		log.Fatalf("multiple instance loading currently not supported")
	}
	if len(is) < 1 {
		log.Fatalf("no instances found")
	}
	instance, err := r.Build(is[0])
	if err != nil {
		log.Fatal(err)
	}

	instance, err = runbin.Run(ctx, os.Stdout, r, instance)
	if err != nil {
		log.Fatalf("error building binaries: %v", err)
	}

	instance, err = imgbuild.Build(ctx, os.Stdout, r, instance)
	if err != nil {
		log.Fatalf("error building images: %v", err)
	}

	deprovision, instance, err := provision.Provision(ctx, os.Stdout, r, instance, kubeconfig)
	defer func() {
		if deprovision != nil && *cleanupCluster {
			deprovision()
		}
	}()
	if err != nil {
		log.Fatalf("couldn't provision a kind cluster: %v", err)
	}

	restConfig, err := f.ToRESTConfig()
	if err != nil {
		log.Fatal(err)
	}

	k, err := dynamic.NewForConfig(restConfig)
	if err != nil {
		log.Fatal(err)
	}

	var state *controller.ClusterState
	go func() {
		mapper, err := f.ToRESTMapper()
		if err != nil {
			log.Fatal(err)
		}

		if state, err = apply.CueInstance(ctx, os.Stdout, k, mapper, &r, instance, false); err != nil {
			log.Fatalf("couldn't configure cluster: %v", err)
		} else {
			fmt.Println("finished configuring cluster")
		}
	}()

	<-c

	if *cleanup && state != nil {
		fmt.Println("cleaning up")
		if err := cuedelete.All(ctx, os.Stdout, k, state.Locators(), v1.DeleteOptions{}); err != nil {
			log.Fatal(err)
		}
	}
}

// TODO: switch to a continuous watch on CUE to drive kubefwd
//"time"
//"github.com/bep/debounce"
//"github.com/txn2/kubefwd/pkg/fwdcfg"
//"github.com/txn2/kubefwd/pkg/fwdhost"
//"github.com/txn2/kubefwd/pkg/fwdport"
//"github.com/txn2/kubefwd/pkg/fwdservice"
//"kubefwd/cmd/kubefwd/services"
//"github.com/txn2/kubefwd/pkg/fwdsvcregistry"
//"github.com/txn2/kubefwd/pkg/utils"
//"github.com/txn2/txeh"
//
//// reqs for kubefwd
//hasRoot, err := utils.CheckRoot()
//if !hasRoot || err != nil {
//	log.Fatal(err)
//}
//hostFile, err := txeh.NewHostsDefault()
//if err != nil {
//	log.Fatalf("HostFile error: %v\n", err)
//}
//_, err = fwdhost.BackupHostFile(hostFile)
//if err != nil {
//	log.Fatalf("Error backing up hostfile: %v\n", err)
//}
//go func() {
//	state := <-final
//
//
//	for id, obj := range state {
//		if id.GroupResource() == "services" {
//
//		}
//	}
//	fwdsvcregistry.Init(ctx.Done())
//
//	clientset, err := f.KubernetesClientSet()
//	if err != nil {
//		log.Fatal("couldn't get clientset")
//	}
//	clientConfig, err := f.ToRESTConfig()
//	if err != nil {
//		log.Fatal("couldn't get restconfig")
//	}
//	restClient, err := f.RESTClient()
//	if err != nil {
//		log.Fatal("couldn't get rest client")
//	}
//	svcfwd := &fwdservice.ServiceFWD{
//		ClientSet:            *clientset,
//		Context:              *name,
//		Namespace:            opts.Namespace,
//		Hostfile:             hostFile,
//		ClientConfig:         *clientConfig,
//		RESTClient:           restClient,
//		NamespaceN:           opts.NamespaceN,
//		ClusterN:             opts.ClusterN,
//		Domain:               opts.Domain,
//		PodLabelSelector:     selector,
//		NamespaceServiceLock: opts.NamespaceIPLock,
//		Svc:                  svc,
//		Headless:             svc.Spec.ClusterIP == "None",
//		PortForwards:         make(map[string]*fwdport.PortForwardOpts),
//		SyncDebouncer:        debounce.New(5 * time.Second),
//		DoneChannel:          make(chan struct{}),
//	}
//	fwdsvcregistry.Add(svcfwd)
//}()
