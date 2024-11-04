# Kubernetes APIs, optionality, and default values

## Summary

Optional fields in Kubernetes APIs often have default values. However, as it turns out, _**default values are only applied IFF the parent object is present in the payload**_. Because programs may be written with the assumption there are default values for nillable fields, this could lead to a nil-pointer exception (NPE). Follow along to better understand when default values in Kubernetes API are and are not applied.

## Requirements

Reproducing the steps outlined in this document requires the following tools:

* `controller-gen`
* `docker` or `podman`
* `kind`
* `kubectl`

For those wanting to follow along, please refer to 


## Widget API

The following snippet of Golang source code describes the `widgets` Kubernetes API:

```golang
package v1alpha1

import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

type Cosmos struct {

	// +optional
	// +kubebuilder:default=World

	Dusty string `json:"dusty,omitempty"`
}

type Helene struct {

	// +optional
	// +kubebuilder:default=Hello

	Beppo string `json:"beppo,omitempty"`

	// +optional
	// +kubebuilder:default=3

	Flarg int32 `json:"flarg,omitempty"`

	// +optional
	// +kubebuilder:default=true

	Narrf bool `json:"narrf,omitempty"`

	// +optional

	Snikt Cosmos `json:"snikt,omitempty"`
}

// WidgetSpec describes the desired state of a widget.
type WidgetSpec struct {
	Moon Helene `json:"moon"`

	// +optional

	Wane Helene `json:"wane,omitempty"`

	// +optional

	Waxy *Helene `json:"waxy,omitempty"`
}

// WidgetStatus describes the observed state of a widget.
type WidgetStatus struct {
}

// +kubebuilder:object:root=true
// +kubebuilder:resource:scope=Cluster
// +kubebuilder:storageversion:true
// +kubebuilder:subresource:status

type Widget struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   WidgetSpec   `json:"spec"`
	Status WidgetStatus `json:"status,omitempty"`
}
```

Notice that `widget.spec` has three fields:

| Field | Optional | Nillable |
|-------|:--------:|:--------:|
| `moon` |  |  |
| `wane` | ✓ |  |
| `waxy` | ✓ | ✓ |

All three fields point to the same data type, `Helene`, which has the following fields itself:

| Field | Optional | Nillable | Type | Default |
|-------|:--------:|:--------:|:----:|:-------:|
| `beppo` | ✓ |  | `string` | `Hello` |
| `flarg` | ✓ |  | `int32` | `3` |
| `narrf` | ✓ |  | `bool` | `true` |
| `snikt` | ✓ |  | `Cosmos` |  |

And finally, the field `snikt` uses a data type named `Cosmos` that has a single field:

| Field | Optional | Nillable | Type | Default |
|-------|:--------:|:--------:|:----:|:-------:|
| `dusty` | ✓ |  | `string` | `World` |


