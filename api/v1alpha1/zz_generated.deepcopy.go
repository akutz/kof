//go:build !ignore_autogenerated

// Code generated by controller-gen. DO NOT EDIT.

package v1alpha1

import (
	"k8s.io/apimachinery/pkg/runtime"
)

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *Cosmos) DeepCopyInto(out *Cosmos) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new Cosmos.
func (in *Cosmos) DeepCopy() *Cosmos {
	if in == nil {
		return nil
	}
	out := new(Cosmos)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *Helene) DeepCopyInto(out *Helene) {
	*out = *in
	out.Snikt = in.Snikt
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new Helene.
func (in *Helene) DeepCopy() *Helene {
	if in == nil {
		return nil
	}
	out := new(Helene)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *Widget) DeepCopyInto(out *Widget) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	in.Spec.DeepCopyInto(&out.Spec)
	out.Status = in.Status
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new Widget.
func (in *Widget) DeepCopy() *Widget {
	if in == nil {
		return nil
	}
	out := new(Widget)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *Widget) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *WidgetSpec) DeepCopyInto(out *WidgetSpec) {
	*out = *in
	out.Moon = in.Moon
	out.Wane = in.Wane
	if in.Waxy != nil {
		in, out := &in.Waxy, &out.Waxy
		*out = new(Helene)
		**out = **in
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new WidgetSpec.
func (in *WidgetSpec) DeepCopy() *WidgetSpec {
	if in == nil {
		return nil
	}
	out := new(WidgetSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *WidgetStatus) DeepCopyInto(out *WidgetStatus) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new WidgetStatus.
func (in *WidgetStatus) DeepCopy() *WidgetStatus {
	if in == nil {
		return nil
	}
	out := new(WidgetStatus)
	in.DeepCopyInto(out)
	return out
}
