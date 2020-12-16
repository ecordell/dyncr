package manifests

IngressNamespace: #Namespace & {
	metadata: {
		name: "ingress-nginx"
		labels: {
			"app.kubernetes.io/name":     "ingress-nginx"
			"app.kubernetes.io/instance": "ingress-nginx"
		}
	}
}

IngressServiceAccount: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx"
		namespace: IngressNamespace.metadata.name
	}
}

IngressConfigMap: #ConfigMap & {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx-controller"
		namespace: "ingress-nginx"
	}
}

IngressClusterRole: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"helm.sh/chart":              "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":     "ingress-nginx"
			"app.kubernetes.io/instance": "ingress-nginx"
			"app.kubernetes.io/version":  "0.41.2"
		}
		name: "ingress-nginx"
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
			"endpoints",
			"nodes",
			"pods",
			"secrets",
		]
		verbs: [
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"nodes",
		]
		verbs: [
			"get",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"services",
		]
		verbs: [
			"get",
			"list",
			"update",
			"watch",
		]
	}, {
		apiGroups: [
			"extensions",
			"networking.k8s.io",
		] // k8s 1.14+
		resources: [
			"ingresses",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"events",
		]
		verbs: [
			"create",
			"patch",
		]
	}, {
		apiGroups: [
			"extensions",
			"networking.k8s.io",
		] // k8s 1.14+
		resources: [
			"ingresses/status",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: ["networking.k8s.io"] // k8s 1.14+
		resources: [
			"ingressclasses",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}

IngressCRB: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"helm.sh/chart":              "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":     "ingress-nginx"
			"app.kubernetes.io/instance": "ingress-nginx"
			"app.kubernetes.io/version":  "0.41.2"
		}
		name: "ingress-nginx"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "ingress-nginx"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "ingress-nginx"
		namespace: "ingress-nginx"
	}]
}

IngressRole: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx"
		namespace: "ingress-nginx"
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"namespaces",
		]
		verbs: [
			"get",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
			"pods",
			"secrets",
			"endpoints",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"services",
		]
		verbs: [
			"get",
			"list",
			"update",
			"watch",
		]
	}, {
		apiGroups: [
			"extensions",
			"networking.k8s.io",
		] // k8s 1.14+
		resources: [
			"ingresses",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"extensions",
			"networking.k8s.io",
		] // k8s 1.14+
		resources: [
			"ingresses/status",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: ["networking.k8s.io"] // k8s 1.14+
		resources: [
			"ingressclasses",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
		]
		resourceNames: [
			"ingress-controller-leader-nginx",
		]
		verbs: [
			"get",
			"update",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
		]
		verbs: [
			"create",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"endpoints",
		]
		verbs: [
			"create",
			"get",
			"update",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"events",
		]
		verbs: [
			"create",
			"patch",
		]
	}]
}
IngressRoleBinding: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx"
		namespace: "ingress-nginx"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "ingress-nginx"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "ingress-nginx"
		namespace: "ingress-nginx"
	}]
}

IngresWebhookService: {
	// Source: ingress-nginx/templates/controller-service-webhook.yaml
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx-controller-admission"
		namespace: "ingress-nginx"
	}
	spec: {
		type: "ClusterIP"
		ports: [{
			name:       "https-webhook"
			port:       443
			targetPort: "webhook"
		}]
		selector: {
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/component": "controller"
		}
	}
}

IngressControllerService: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx-controller"
		namespace: "ingress-nginx"
	}
	spec: {
		type: "NodePort"
		ports: [{
			name:       "http"
			port:       80
			protocol:   "TCP"
			targetPort: "http"
		}, {
			name:       "https"
			port:       443
			protocol:   "TCP"
			targetPort: "https"
		}]
		selector: {
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/component": "controller"
		}
	}
}

IngressControllerDeployment: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "controller"
		}
		name:      "ingress-nginx-controller"
		namespace: "ingress-nginx"
	}
	spec: {
		selector: matchLabels: {
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/component": "controller"
		}
		revisionHistoryLimit: 10
		strategy: {
			rollingUpdate: maxUnavailable: 1
			type: "RollingUpdate"
		}
		minReadySeconds: 0
		template: {
			metadata: labels: {
				"app.kubernetes.io/name":      "ingress-nginx"
				"app.kubernetes.io/instance":  "ingress-nginx"
				"app.kubernetes.io/component": "controller"
			}
			spec: {
				dnsPolicy: "ClusterFirst"
				containers: [{
					name:            "controller"
					image:           "k8s.gcr.io/ingress-nginx/controller:v0.41.2@sha256:1f4f402b9c14f3ae92b11ada1dfe9893a88f0faeb0b2f4b903e2c67a0c3bf0de"
					imagePullPolicy: "IfNotPresent"
					lifecycle: preStop: exec: command: [
						"/wait-shutdown",
					]
					args: [
						"/nginx-ingress-controller",
						"--election-id=ingress-controller-leader",
						"--ingress-class=nginx",
						"--configmap=$(POD_NAMESPACE)/ingress-nginx-controller",
						"--validating-webhook=:8443",
						"--validating-webhook-certificate=/usr/local/certificates/cert",
						"--validating-webhook-key=/usr/local/certificates/key",
						"--publish-status-address=localhost",
					]
					securityContext: {
						capabilities: {
							drop: [
								"ALL",
							]
							add: [
								"NET_BIND_SERVICE",
							]
						}
						runAsUser:                101
						allowPrivilegeEscalation: true
					}
					env: [{
						name: "POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name: "POD_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name:  "LD_PRELOAD"
						value: "/usr/local/lib/libmimalloc.so"
					}]
					livenessProbe: {
						httpGet: {
							path:   "/healthz"
							port:   10254
							scheme: "HTTP"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						timeoutSeconds:      1
						successThreshold:    1
						failureThreshold:    5
					}
					readinessProbe: {
						httpGet: {
							path:   "/healthz"
							port:   10254
							scheme: "HTTP"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						timeoutSeconds:      1
						successThreshold:    1
						failureThreshold:    3
					}
					ports: [{
						name:          "http"
						containerPort: 80
						protocol:      "TCP"
						hostPort:      80
					}, {
						name:          "https"
						containerPort: 443
						protocol:      "TCP"
						hostPort:      443
					}, {
						name:          "webhook"
						containerPort: 8443
						protocol:      "TCP"
					}]
					volumeMounts: [{
						name:      "webhook-cert"
						mountPath: "/usr/local/certificates/"
						readOnly:  true
					}]
					resources: requests: {
						cpu:    "100m"
						memory: "90Mi"
					}
				}]
				nodeSelector: {
					"kubernetes.io/os": "linux"
				}
				serviceAccountName:            "ingress-nginx"
				terminationGracePeriodSeconds: 0
				volumes: [{
					name: "webhook-cert"
					secret: secretName: "ingress-nginx-admission"
				}]
			}
		}
	}
}

IngressWebhook: {
	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "ValidatingWebhookConfiguration"
	metadata: {
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		name: "ingress-nginx-admission"
	}
	webhooks: [{
		name:        "validate.nginx.ingress.kubernetes.io"
		matchPolicy: "Equivalent"
		rules: [{
			apiGroups: [
				"networking.k8s.io",
			]
			apiVersions: [
				"v1beta1",
			]
			operations: [
				"CREATE",
				"UPDATE",
			]
			resources: [
				"ingresses",
			]
		}]
		failurePolicy: "Fail"
		sideEffects:   "None"
		admissionReviewVersions: [
			"v1",
			"v1beta1",
		]
		clientConfig: service: {
			namespace: "ingress-nginx"
			name:      "ingress-nginx-controller-admission"
			path:      "/networking/v1beta1/ingresses"
		}
	}]
}

IngressAdmissionServiceAccount: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name: "ingress-nginx-admission"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade,post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		namespace: "ingress-nginx"
	}
}

IngressAdmissionClusterRole: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		name: "ingress-nginx-admission"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade,post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
	}
	rules: [{
		apiGroups: [
			"admissionregistration.k8s.io",
		]
		resources: [
			"validatingwebhookconfigurations",
		]
		verbs: [
			"get",
			"update",
		]
	}]
}

IngressAdmissionCRB: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name: "ingress-nginx-admission"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade,post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "ingress-nginx-admission"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "ingress-nginx-admission"
		namespace: "ingress-nginx"
	}]
}

IngressAdmissionRole: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		name: "ingress-nginx-admission"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade,post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		namespace: "ingress-nginx"
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"secrets",
		]
		verbs: [
			"get",
			"create",
		]
	}]
}

IngressAdmissionRoleBinding: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name: "ingress-nginx-admission"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade,post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		namespace: "ingress-nginx"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "ingress-nginx-admission"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "ingress-nginx-admission"
		namespace: "ingress-nginx"
	}]
}

IngressSecretJob: {
	apiVersion: "batch/v1"
	kind:       "Job"
	metadata: {
		name: "ingress-nginx-admission-create"
		annotations: {
			"helm.sh/hook":               "pre-install,pre-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		namespace: "ingress-nginx"
	}
	spec: template: {
		metadata: {
			name: "ingress-nginx-admission-create"
			labels: {
				"helm.sh/chart":               "ingress-nginx-3.10.1"
				"app.kubernetes.io/name":      "ingress-nginx"
				"app.kubernetes.io/instance":  "ingress-nginx"
				"app.kubernetes.io/version":   "0.41.2"
				"app.kubernetes.io/component": "admission-webhook"
			}
		}
		spec: {
			containers: [{
				name:            "create"
				image:           "docker.io/jettech/kube-webhook-certgen:v1.5.0"
				imagePullPolicy: "IfNotPresent"
				args: [
					"create",
					"--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc",
					"--namespace=$(POD_NAMESPACE)",
					"--secret-name=ingress-nginx-admission",
				]
				env: [{
					name: "POD_NAMESPACE"
					valueFrom: fieldRef: fieldPath: "metadata.namespace"
				}]
			}]
			restartPolicy:      "OnFailure"
			serviceAccountName: "ingress-nginx-admission"
			securityContext: {
				runAsNonRoot: true
				runAsUser:    2000
			}
		}
	}
}

IngressAdmissionJob: {
	apiVersion: "batch/v1"
	kind:       "Job"
	metadata: {
		name: "ingress-nginx-admission-patch"
		annotations: {
			"helm.sh/hook":               "post-install,post-upgrade"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}
		labels: {
			"helm.sh/chart":               "ingress-nginx-3.10.1"
			"app.kubernetes.io/name":      "ingress-nginx"
			"app.kubernetes.io/instance":  "ingress-nginx"
			"app.kubernetes.io/version":   "0.41.2"
			"app.kubernetes.io/component": "admission-webhook"
		}
		namespace: "ingress-nginx"
	}
	spec: template: {
		metadata: {
			name: "ingress-nginx-admission-patch"
			labels: {
				"helm.sh/chart":               "ingress-nginx-3.10.1"
				"app.kubernetes.io/name":      "ingress-nginx"
				"app.kubernetes.io/instance":  "ingress-nginx"
				"app.kubernetes.io/version":   "0.41.2"
				"app.kubernetes.io/component": "admission-webhook"
			}
		}
		spec: {
			containers: [{
				name:            "patch"
				image:           "docker.io/jettech/kube-webhook-certgen:v1.5.0"
				imagePullPolicy: "IfNotPresent"
				args: [
					"patch",
					"--webhook-name=ingress-nginx-admission",
					"--namespace=$(POD_NAMESPACE)",
					"--patch-mutating=false",
					"--secret-name=ingress-nginx-admission",
					"--patch-failure-policy=Fail",
				]
				env: [{
					name: "POD_NAMESPACE"
					valueFrom: fieldRef: fieldPath: "metadata.namespace"
				}]
			}]
			restartPolicy:      "OnFailure"
			serviceAccountName: "ingress-nginx-admission"
			securityContext: {
				runAsNonRoot: true
				runAsUser:    2000
			}
		}
	}
}
