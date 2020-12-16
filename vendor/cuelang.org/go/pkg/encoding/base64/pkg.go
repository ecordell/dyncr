// Code generated by go generate. DO NOT EDIT.

//go:generate rm pkg.go
//go:generate go run ../../gen/gen.go

package base64

import (
	"cuelang.org/go/internal/core/adt"
	"cuelang.org/go/pkg/internal"
)

func init() {
	internal.Register("encoding/base64", pkg)
}

var _ = adt.TopKind // in case the adt package isn't used

var pkg = &internal.Package{
	Native: []*internal.Builtin{{
		Name:   "EncodedLen",
		Params: []adt.Kind{adt.TopKind, adt.IntKind},
		Result: adt.IntKind,
		Func: func(c *internal.CallCtxt) {
			encoding, n := c.Value(0), c.Int(1)
			if c.Do() {
				c.Ret, c.Err = EncodedLen(encoding, n)
			}
		},
	}, {
		Name:   "DecodedLen",
		Params: []adt.Kind{adt.TopKind, adt.IntKind},
		Result: adt.IntKind,
		Func: func(c *internal.CallCtxt) {
			encoding, x := c.Value(0), c.Int(1)
			if c.Do() {
				c.Ret, c.Err = DecodedLen(encoding, x)
			}
		},
	}, {
		Name:   "Encode",
		Params: []adt.Kind{adt.TopKind, adt.BytesKind | adt.StringKind},
		Result: adt.StringKind,
		Func: func(c *internal.CallCtxt) {
			encoding, src := c.Value(0), c.Bytes(1)
			if c.Do() {
				c.Ret, c.Err = Encode(encoding, src)
			}
		},
	}, {
		Name:   "Decode",
		Params: []adt.Kind{adt.TopKind, adt.StringKind},
		Result: adt.BytesKind | adt.StringKind,
		Func: func(c *internal.CallCtxt) {
			encoding, s := c.Value(0), c.String(1)
			if c.Do() {
				c.Ret, c.Err = Decode(encoding, s)
			}
		},
	}},
}
