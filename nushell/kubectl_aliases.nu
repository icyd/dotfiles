# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

alias ksys = kubectl --namespace=kube-system
alias ka = kubectl apply --recursive -f
alias ksysa = kubectl --namespace=kube-system apply --recursive -f
alias kak = kubectl apply -k
alias kk = kubectl kustomize
alias kex = kubectl exec -i -t
alias ksysex = kubectl --namespace=kube-system exec -i -t
alias klo = kubectl logs -f
alias ksyslo = kubectl --namespace=kube-system logs -f
alias klop = kubectl logs -f -p
alias ksyslop = kubectl --namespace=kube-system logs -f -p
alias kp = kubectl proxy
alias kpf = kubectl port-forward
alias kg = kubectl get
alias ksysg = kubectl --namespace=kube-system get
alias kd = kubectl describe
alias ksysd = kubectl --namespace=kube-system describe
alias krm = kubectl delete
alias ksysrm = kubectl --namespace=kube-system delete
alias krun = kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t
alias ksysrun = kubectl --namespace=kube-system run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t
alias kgpo = kubectl get pods
alias ksysgpo = kubectl --namespace=kube-system get pods
alias kdpo = kubectl describe pods
alias ksysdpo = kubectl --namespace=kube-system describe pods
alias krmpo = kubectl delete pods
alias ksysrmpo = kubectl --namespace=kube-system delete pods
alias kgdep = kubectl get deployment
alias ksysgdep = kubectl --namespace=kube-system get deployment
alias kddep = kubectl describe deployment
alias ksysddep = kubectl --namespace=kube-system describe deployment
alias krmdep = kubectl delete deployment
alias ksysrmdep = kubectl --namespace=kube-system delete deployment
alias kgsts = kubectl get statefulset
alias ksysgsts = kubectl --namespace=kube-system get statefulset
alias kdsts = kubectl describe statefulset
alias ksysdsts = kubectl --namespace=kube-system describe statefulset
alias krmsts = kubectl delete statefulset
alias ksysrmsts = kubectl --namespace=kube-system delete statefulset
alias kgsvc = kubectl get service
alias ksysgsvc = kubectl --namespace=kube-system get service
alias kdsvc = kubectl describe service
alias ksysdsvc = kubectl --namespace=kube-system describe service
alias krmsvc = kubectl delete service
alias ksysrmsvc = kubectl --namespace=kube-system delete service
alias kging = kubectl get ingress
alias ksysging = kubectl --namespace=kube-system get ingress
alias kding = kubectl describe ingress
alias ksysding = kubectl --namespace=kube-system describe ingress
alias krming = kubectl delete ingress
alias ksysrming = kubectl --namespace=kube-system delete ingress
alias kgcm = kubectl get configmap
alias ksysgcm = kubectl --namespace=kube-system get configmap
alias kdcm = kubectl describe configmap
alias ksysdcm = kubectl --namespace=kube-system describe configmap
alias krmcm = kubectl delete configmap
alias ksysrmcm = kubectl --namespace=kube-system delete configmap
alias kgsec = kubectl get secret
alias ksysgsec = kubectl --namespace=kube-system get secret
alias kdsec = kubectl describe secret
alias ksysdsec = kubectl --namespace=kube-system describe secret
alias krmsec = kubectl delete secret
alias ksysrmsec = kubectl --namespace=kube-system delete secret
alias kgno = kubectl get nodes
alias kdno = kubectl describe nodes
alias kgns = kubectl get namespaces
alias kdns = kubectl describe namespaces
alias krmns = kubectl delete namespaces
alias kgoyaml = kubectl get -o=yaml
alias ksysgoyaml = kubectl --namespace=kube-system get -o=yaml
alias kgpooyaml = kubectl get pods -o=yaml
alias ksysgpooyaml = kubectl --namespace=kube-system get pods -o=yaml
alias kgdepoyaml = kubectl get deployment -o=yaml
alias ksysgdepoyaml = kubectl --namespace=kube-system get deployment -o=yaml
alias kgstsoyaml = kubectl get statefulset -o=yaml
alias ksysgstsoyaml = kubectl --namespace=kube-system get statefulset -o=yaml
alias kgsvcoyaml = kubectl get service -o=yaml
alias ksysgsvcoyaml = kubectl --namespace=kube-system get service -o=yaml
alias kgingoyaml = kubectl get ingress -o=yaml
alias ksysgingoyaml = kubectl --namespace=kube-system get ingress -o=yaml
alias kgcmoyaml = kubectl get configmap -o=yaml
alias ksysgcmoyaml = kubectl --namespace=kube-system get configmap -o=yaml
alias kgsecoyaml = kubectl get secret -o=yaml
alias ksysgsecoyaml = kubectl --namespace=kube-system get secret -o=yaml
alias kgnooyaml = kubectl get nodes -o=yaml
alias kgnsoyaml = kubectl get namespaces -o=yaml
alias kgowide = kubectl get -o=wide
alias ksysgowide = kubectl --namespace=kube-system get -o=wide
alias kgpoowide = kubectl get pods -o=wide
alias ksysgpoowide = kubectl --namespace=kube-system get pods -o=wide
alias kgdepowide = kubectl get deployment -o=wide
alias ksysgdepowide = kubectl --namespace=kube-system get deployment -o=wide
alias kgstsowide = kubectl get statefulset -o=wide
alias ksysgstsowide = kubectl --namespace=kube-system get statefulset -o=wide
alias kgsvcowide = kubectl get service -o=wide
alias ksysgsvcowide = kubectl --namespace=kube-system get service -o=wide
alias kgingowide = kubectl get ingress -o=wide
alias ksysgingowide = kubectl --namespace=kube-system get ingress -o=wide
alias kgcmowide = kubectl get configmap -o=wide
alias ksysgcmowide = kubectl --namespace=kube-system get configmap -o=wide
alias kgsecowide = kubectl get secret -o=wide
alias ksysgsecowide = kubectl --namespace=kube-system get secret -o=wide
alias kgnoowide = kubectl get nodes -o=wide
alias kgnsowide = kubectl get namespaces -o=wide
alias kgojson = kubectl get -o=json
alias ksysgojson = kubectl --namespace=kube-system get -o=json
alias kgpoojson = kubectl get pods -o=json
alias ksysgpoojson = kubectl --namespace=kube-system get pods -o=json
alias kgdepojson = kubectl get deployment -o=json
alias ksysgdepojson = kubectl --namespace=kube-system get deployment -o=json
alias kgstsojson = kubectl get statefulset -o=json
alias ksysgstsojson = kubectl --namespace=kube-system get statefulset -o=json
alias kgsvcojson = kubectl get service -o=json
alias ksysgsvcojson = kubectl --namespace=kube-system get service -o=json
alias kgingojson = kubectl get ingress -o=json
alias ksysgingojson = kubectl --namespace=kube-system get ingress -o=json
alias kgcmojson = kubectl get configmap -o=json
alias ksysgcmojson = kubectl --namespace=kube-system get configmap -o=json
alias kgsecojson = kubectl get secret -o=json
alias ksysgsecojson = kubectl --namespace=kube-system get secret -o=json
alias kgnoojson = kubectl get nodes -o=json
alias kgnsojson = kubectl get namespaces -o=json
alias kgall = kubectl get --all-namespaces
alias kdall = kubectl describe --all-namespaces
alias kgpoall = kubectl get pods --all-namespaces
alias kdpoall = kubectl describe pods --all-namespaces
alias kgdepall = kubectl get deployment --all-namespaces
alias kddepall = kubectl describe deployment --all-namespaces
alias kgstsall = kubectl get statefulset --all-namespaces
alias kdstsall = kubectl describe statefulset --all-namespaces
alias kgsvcall = kubectl get service --all-namespaces
alias kdsvcall = kubectl describe service --all-namespaces
alias kgingall = kubectl get ingress --all-namespaces
alias kdingall = kubectl describe ingress --all-namespaces
alias kgcmall = kubectl get configmap --all-namespaces
alias kdcmall = kubectl describe configmap --all-namespaces
alias kgsecall = kubectl get secret --all-namespaces
alias kdsecall = kubectl describe secret --all-namespaces
alias kgnsall = kubectl get namespaces --all-namespaces
alias kdnsall = kubectl describe namespaces --all-namespaces
alias kgsl = kubectl get --show-labels
alias ksysgsl = kubectl --namespace=kube-system get --show-labels
alias kgposl = kubectl get pods --show-labels
alias ksysgposl = kubectl --namespace=kube-system get pods --show-labels
alias kgdepsl = kubectl get deployment --show-labels
alias ksysgdepsl = kubectl --namespace=kube-system get deployment --show-labels
alias kgstssl = kubectl get statefulset --show-labels
alias ksysgstssl = kubectl --namespace=kube-system get statefulset --show-labels
alias kgsvcsl = kubectl get service --show-labels
alias ksysgsvcsl = kubectl --namespace=kube-system get service --show-labels
alias kgingsl = kubectl get ingress --show-labels
alias ksysgingsl = kubectl --namespace=kube-system get ingress --show-labels
alias kgcmsl = kubectl get configmap --show-labels
alias ksysgcmsl = kubectl --namespace=kube-system get configmap --show-labels
alias kgsecsl = kubectl get secret --show-labels
alias ksysgsecsl = kubectl --namespace=kube-system get secret --show-labels
alias kgnosl = kubectl get nodes --show-labels
alias kgnssl = kubectl get namespaces --show-labels
alias krmall = kubectl delete --all
alias ksysrmall = kubectl --namespace=kube-system delete --all
alias krmpoall = kubectl delete pods --all
alias ksysrmpoall = kubectl --namespace=kube-system delete pods --all
alias krmdepall = kubectl delete deployment --all
alias ksysrmdepall = kubectl --namespace=kube-system delete deployment --all
alias krmstsall = kubectl delete statefulset --all
alias ksysrmstsall = kubectl --namespace=kube-system delete statefulset --all
alias krmsvcall = kubectl delete service --all
alias ksysrmsvcall = kubectl --namespace=kube-system delete service --all
alias krmingall = kubectl delete ingress --all
alias ksysrmingall = kubectl --namespace=kube-system delete ingress --all
alias krmcmall = kubectl delete configmap --all
alias ksysrmcmall = kubectl --namespace=kube-system delete configmap --all
alias krmsecall = kubectl delete secret --all
alias ksysrmsecall = kubectl --namespace=kube-system delete secret --all
alias krmnsall = kubectl delete namespaces --all
alias kgw = hwatch "kubectl get"
alias ksysgw = hwatch "kubectl --namespace=kube-system get"
alias kgpow = hwatch "kubectl get pods"
alias ksysgpow = hwatch "kubectl --namespace=kube-system get pods"
alias kgdepw = hwatch "kubectl get deployment"
alias ksysgdepw = hwatch "kubectl --namespace=kube-system get deployment"
alias kgstsw = hwatch "kubectl get statefulset"
alias ksysgstsw = hwatch "kubectl --namespace=kube-system get statefulset"
alias kgsvcw = hwatch "kubectl get service"
alias ksysgsvcw = hwatch "kubectl --namespace=kube-system get service"
alias kgingw = hwatch "kubectl get ingress"
alias ksysgingw = hwatch "kubectl --namespace=kube-system get ingress"
alias kgcmw = hwatch "kubectl get configmap"
alias ksysgcmw = hwatch "kubectl --namespace=kube-system get configmap"
alias kgsecw = hwatch "kubectl get secret"
alias ksysgsecw = hwatch "kubectl --namespace=kube-system get secret"
alias kgnow = hwatch "kubectl get nodes"
alias kgnsw = hwatch "kubectl get namespaces"
alias kgoyamlall = kubectl get -o=yaml --all-namespaces
alias kgpooyamlall = kubectl get pods -o=yaml --all-namespaces
alias kgdepoyamlall = kubectl get deployment -o=yaml --all-namespaces
alias kgstsoyamlall = kubectl get statefulset -o=yaml --all-namespaces
alias kgsvcoyamlall = kubectl get service -o=yaml --all-namespaces
alias kgingoyamlall = kubectl get ingress -o=yaml --all-namespaces
alias kgcmoyamlall = kubectl get configmap -o=yaml --all-namespaces
alias kgsecoyamlall = kubectl get secret -o=yaml --all-namespaces
alias kgnsoyamlall = kubectl get namespaces -o=yaml --all-namespaces
alias kgalloyaml = kubectl get --all-namespaces -o=yaml
alias kgpoalloyaml = kubectl get pods --all-namespaces -o=yaml
alias kgdepalloyaml = kubectl get deployment --all-namespaces -o=yaml
alias kgstsalloyaml = kubectl get statefulset --all-namespaces -o=yaml
alias kgsvcalloyaml = kubectl get service --all-namespaces -o=yaml
alias kgingalloyaml = kubectl get ingress --all-namespaces -o=yaml
alias kgcmalloyaml = kubectl get configmap --all-namespaces -o=yaml
alias kgsecalloyaml = kubectl get secret --all-namespaces -o=yaml
alias kgnsalloyaml = kubectl get namespaces --all-namespaces -o=yaml
alias kgwoyaml = hwatch "kubectl get -o=yaml"
alias ksysgwoyaml = hwatch "kubectl --namespace=kube-system get -o=yaml"
alias kgpowoyaml = hwatch "kubectl get pods -o=yaml"
alias ksysgpowoyaml = hwatch "kubectl --namespace=kube-system get pods -o=yaml"
alias kgdepwoyaml = hwatch "kubectl get deployment -o=yaml"
alias ksysgdepwoyaml = hwatch "kubectl --namespace=kube-system get deployment -o=yaml"
alias kgstswoyaml = hwatch "kubectl get statefulset -o=yaml"
alias ksysgstswoyaml = hwatch "kubectl --namespace=kube-system get statefulset -o=yaml"
alias kgsvcwoyaml = hwatch "kubectl get service -o=yaml"
alias ksysgsvcwoyaml = hwatch "kubectl --namespace=kube-system get service -o=yaml"
alias kgingwoyaml = hwatch "kubectl get ingress -o=yaml"
alias ksysgingwoyaml = hwatch "kubectl --namespace=kube-system get ingress -o=yaml"
alias kgcmwoyaml = hwatch "kubectl get configmap -o=yaml"
alias ksysgcmwoyaml = hwatch "kubectl --namespace=kube-system get configmap -o=yaml"
alias kgsecwoyaml = hwatch "kubectl get secret -o=yaml"
alias ksysgsecwoyaml = hwatch "kubectl --namespace=kube-system get secret -o=yaml"
alias kgnowoyaml = hwatch "kubectl get nodes -o=yaml"
alias kgnswoyaml = hwatch "kubectl get namespaces -o=yaml"
alias kgowideall = kubectl get -o=wide --all-namespaces
alias kgpoowideall = kubectl get pods -o=wide --all-namespaces
alias kgdepowideall = kubectl get deployment -o=wide --all-namespaces
alias kgstsowideall = kubectl get statefulset -o=wide --all-namespaces
alias kgsvcowideall = kubectl get service -o=wide --all-namespaces
alias kgingowideall = kubectl get ingress -o=wide --all-namespaces
alias kgcmowideall = kubectl get configmap -o=wide --all-namespaces
alias kgsecowideall = kubectl get secret -o=wide --all-namespaces
alias kgnsowideall = kubectl get namespaces -o=wide --all-namespaces
alias kgallowide = kubectl get --all-namespaces -o=wide
alias kgpoallowide = kubectl get pods --all-namespaces -o=wide
alias kgdepallowide = kubectl get deployment --all-namespaces -o=wide
alias kgstsallowide = kubectl get statefulset --all-namespaces -o=wide
alias kgsvcallowide = kubectl get service --all-namespaces -o=wide
alias kgingallowide = kubectl get ingress --all-namespaces -o=wide
alias kgcmallowide = kubectl get configmap --all-namespaces -o=wide
alias kgsecallowide = kubectl get secret --all-namespaces -o=wide
alias kgnsallowide = kubectl get namespaces --all-namespaces -o=wide
alias kgowidesl = kubectl get -o=wide --show-labels
alias ksysgowidesl = kubectl --namespace=kube-system get -o=wide --show-labels
alias kgpoowidesl = kubectl get pods -o=wide --show-labels
alias ksysgpoowidesl = kubectl --namespace=kube-system get pods -o=wide --show-labels
alias kgdepowidesl = kubectl get deployment -o=wide --show-labels
alias ksysgdepowidesl = kubectl --namespace=kube-system get deployment -o=wide --show-labels
alias kgstsowidesl = kubectl get statefulset -o=wide --show-labels
alias ksysgstsowidesl = kubectl --namespace=kube-system get statefulset -o=wide --show-labels
alias kgsvcowidesl = kubectl get service -o=wide --show-labels
alias ksysgsvcowidesl = kubectl --namespace=kube-system get service -o=wide --show-labels
alias kgingowidesl = kubectl get ingress -o=wide --show-labels
alias ksysgingowidesl = kubectl --namespace=kube-system get ingress -o=wide --show-labels
alias kgcmowidesl = kubectl get configmap -o=wide --show-labels
alias ksysgcmowidesl = kubectl --namespace=kube-system get configmap -o=wide --show-labels
alias kgsecowidesl = kubectl get secret -o=wide --show-labels
alias ksysgsecowidesl = kubectl --namespace=kube-system get secret -o=wide --show-labels
alias kgnoowidesl = kubectl get nodes -o=wide --show-labels
alias kgnsowidesl = kubectl get namespaces -o=wide --show-labels
alias kgslowide = kubectl get --show-labels -o=wide
alias ksysgslowide = kubectl --namespace=kube-system get --show-labels -o=wide
alias kgposlowide = kubectl get pods --show-labels -o=wide
alias ksysgposlowide = kubectl --namespace=kube-system get pods --show-labels -o=wide
alias kgdepslowide = kubectl get deployment --show-labels -o=wide
alias ksysgdepslowide = kubectl --namespace=kube-system get deployment --show-labels -o=wide
alias kgstsslowide = kubectl get statefulset --show-labels -o=wide
alias ksysgstsslowide = kubectl --namespace=kube-system get statefulset --show-labels -o=wide
alias kgsvcslowide = kubectl get service --show-labels -o=wide
alias ksysgsvcslowide = kubectl --namespace=kube-system get service --show-labels -o=wide
alias kgingslowide = kubectl get ingress --show-labels -o=wide
alias ksysgingslowide = kubectl --namespace=kube-system get ingress --show-labels -o=wide
alias kgcmslowide = kubectl get configmap --show-labels -o=wide
alias ksysgcmslowide = kubectl --namespace=kube-system get configmap --show-labels -o=wide
alias kgsecslowide = kubectl get secret --show-labels -o=wide
alias ksysgsecslowide = kubectl --namespace=kube-system get secret --show-labels -o=wide
alias kgnoslowide = kubectl get nodes --show-labels -o=wide
alias kgnsslowide = kubectl get namespaces --show-labels -o=wide
alias kgwowide = hwatch "kubectl get -o=wide"
alias ksysgwowide = hwatch "kubectl --namespace=kube-system get -o=wide"
alias kgpowowide = hwatch "kubectl get pods -o=wide"
alias ksysgpowowide = hwatch "kubectl --namespace=kube-system get pods -o=wide"
alias kgdepwowide = hwatch "kubectl get deployment -o=wide"
alias ksysgdepwowide = hwatch "kubectl --namespace=kube-system get deployment -o=wide"
alias kgstswowide = hwatch "kubectl get statefulset -o=wide"
alias ksysgstswowide = hwatch "kubectl --namespace=kube-system get statefulset -o=wide"
alias kgsvcwowide = hwatch "kubectl get service -o=wide"
alias ksysgsvcwowide = hwatch "kubectl --namespace=kube-system get service -o=wide"
alias kgingwowide = hwatch "kubectl get ingress -o=wide"
alias ksysgingwowide = hwatch "kubectl --namespace=kube-system get ingress -o=wide"
alias kgcmwowide = hwatch "kubectl get configmap -o=wide"
alias ksysgcmwowide = hwatch "kubectl --namespace=kube-system get configmap -o=wide"
alias kgsecwowide = hwatch "kubectl get secret -o=wide"
alias ksysgsecwowide = hwatch "kubectl --namespace=kube-system get secret -o=wide"
alias kgnowowide = hwatch "kubectl get nodes -o=wide"
alias kgnswowide = hwatch "kubectl get namespaces -o=wide"
alias kgojsonall = kubectl get -o=json --all-namespaces
alias kgpoojsonall = kubectl get pods -o=json --all-namespaces
alias kgdepojsonall = kubectl get deployment -o=json --all-namespaces
alias kgstsojsonall = kubectl get statefulset -o=json --all-namespaces
alias kgsvcojsonall = kubectl get service -o=json --all-namespaces
alias kgingojsonall = kubectl get ingress -o=json --all-namespaces
alias kgcmojsonall = kubectl get configmap -o=json --all-namespaces
alias kgsecojsonall = kubectl get secret -o=json --all-namespaces
alias kgnsojsonall = kubectl get namespaces -o=json --all-namespaces
alias kgallojson = kubectl get --all-namespaces -o=json
alias kgpoallojson = kubectl get pods --all-namespaces -o=json
alias kgdepallojson = kubectl get deployment --all-namespaces -o=json
alias kgstsallojson = kubectl get statefulset --all-namespaces -o=json
alias kgsvcallojson = kubectl get service --all-namespaces -o=json
alias kgingallojson = kubectl get ingress --all-namespaces -o=json
alias kgcmallojson = kubectl get configmap --all-namespaces -o=json
alias kgsecallojson = kubectl get secret --all-namespaces -o=json
alias kgnsallojson = kubectl get namespaces --all-namespaces -o=json
alias kgwojson = hwatch "kubectl get -o=json"
alias ksysgwojson = hwatch "kubectl --namespace=kube-system get -o=json"
alias kgpowojson = hwatch "kubectl get pods -o=json"
alias ksysgpowojson = hwatch "kubectl --namespace=kube-system get pods -o=json"
alias kgdepwojson = hwatch "kubectl get deployment -o=json"
alias ksysgdepwojson = hwatch "kubectl --namespace=kube-system get deployment -o=json"
alias kgstswojson = hwatch "kubectl get statefulset -o=json"
alias ksysgstswojson = hwatch "kubectl --namespace=kube-system get statefulset -o=json"
alias kgsvcwojson = hwatch "kubectl get service -o=json"
alias ksysgsvcwojson = hwatch "kubectl --namespace=kube-system get service -o=json"
alias kgingwojson = hwatch "kubectl get ingress -o=json"
alias ksysgingwojson = hwatch "kubectl --namespace=kube-system get ingress -o=json"
alias kgcmwojson = hwatch "kubectl get configmap -o=json"
alias ksysgcmwojson = hwatch "kubectl --namespace=kube-system get configmap -o=json"
alias kgsecwojson = hwatch "kubectl get secret -o=json"
alias ksysgsecwojson = hwatch "kubectl --namespace=kube-system get secret -o=json"
alias kgnowojson = hwatch "kubectl get nodes -o=json"
alias kgnswojson = hwatch "kubectl get namespaces -o=json"
alias kgallsl = kubectl get --all-namespaces --show-labels
alias kgpoallsl = kubectl get pods --all-namespaces --show-labels
alias kgdepallsl = kubectl get deployment --all-namespaces --show-labels
alias kgstsallsl = kubectl get statefulset --all-namespaces --show-labels
alias kgsvcallsl = kubectl get service --all-namespaces --show-labels
alias kgingallsl = kubectl get ingress --all-namespaces --show-labels
alias kgcmallsl = kubectl get configmap --all-namespaces --show-labels
alias kgsecallsl = kubectl get secret --all-namespaces --show-labels
alias kgnsallsl = kubectl get namespaces --all-namespaces --show-labels
alias kgslall = kubectl get --show-labels --all-namespaces
alias kgposlall = kubectl get pods --show-labels --all-namespaces
alias kgdepslall = kubectl get deployment --show-labels --all-namespaces
alias kgstsslall = kubectl get statefulset --show-labels --all-namespaces
alias kgsvcslall = kubectl get service --show-labels --all-namespaces
alias kgingslall = kubectl get ingress --show-labels --all-namespaces
alias kgcmslall = kubectl get configmap --show-labels --all-namespaces
alias kgsecslall = kubectl get secret --show-labels --all-namespaces
alias kgnsslall = kubectl get namespaces --show-labels --all-namespaces
alias kgallw = hwatch "kubectl get --all-namespaces"
alias kgpoallw = hwatch "kubectl get pods --all-namespaces"
alias kgdepallw = hwatch "kubectl get deployment --all-namespaces"
alias kgstsallw = hwatch "kubectl get statefulset --all-namespaces"
alias kgsvcallw = hwatch "kubectl get service --all-namespaces"
alias kgingallw = hwatch "kubectl get ingress --all-namespaces"
alias kgcmallw = hwatch "kubectl get configmap --all-namespaces"
alias kgsecallw = hwatch "kubectl get secret --all-namespaces"
alias kgnsallw = hwatch "kubectl get namespaces --all-namespaces"
alias kgwall = hwatch "kubectl get --all-namespaces"
alias kgpowall = hwatch "kubectl get pods --all-namespaces"
alias kgdepwall = hwatch "kubectl get deployment --all-namespaces"
alias kgstswall = hwatch "kubectl get statefulset --all-namespaces"
alias kgsvcwall = hwatch "kubectl get service --all-namespaces"
alias kgingwall = hwatch "kubectl get ingress --all-namespaces"
alias kgcmwall = hwatch "kubectl get configmap --all-namespaces"
alias kgsecwall = hwatch "kubectl get secret --all-namespaces"
alias kgnswall = hwatch "kubectl get namespaces --all-namespaces"
alias kgslw = hwatch "kubectl get --show-labels"
alias ksysgslw = hwatch "kubectl --namespace=kube-system get --show-labels"
alias kgposlw = hwatch "kubectl get pods --show-labels"
alias ksysgposlw = hwatch "kubectl --namespace=kube-system get pods --show-labels"
alias kgdepslw = hwatch "kubectl get deployment --show-labels"
alias ksysgdepslw = hwatch "kubectl --namespace=kube-system get deployment --show-labels"
alias kgstsslw = hwatch "kubectl get statefulset --show-labels"
alias ksysgstsslw = hwatch "kubectl --namespace=kube-system get statefulset --show-labels"
alias kgsvcslw = hwatch "kubectl get service --show-labels"
alias ksysgsvcslw = hwatch "kubectl --namespace=kube-system get service --show-labels"
alias kgingslw = hwatch "kubectl get ingress --show-labels"
alias ksysgingslw = hwatch "kubectl --namespace=kube-system get ingress --show-labels"
alias kgcmslw = hwatch "kubectl get configmap --show-labels"
alias ksysgcmslw = hwatch "kubectl --namespace=kube-system get configmap --show-labels"
alias kgsecslw = hwatch "kubectl get secret --show-labels"
alias ksysgsecslw = hwatch "kubectl --namespace=kube-system get secret --show-labels"
alias kgnoslw = hwatch "kubectl get nodes --show-labels"
alias kgnsslw = hwatch "kubectl get namespaces --show-labels"
alias kgwsl = hwatch "kubectl get --show-labels"
alias ksysgwsl = hwatch "kubectl --namespace=kube-system get --show-labels"
alias kgpowsl = hwatch "kubectl get pods --show-labels"
alias ksysgpowsl = hwatch "kubectl --namespace=kube-system get pods --show-labels"
alias kgdepwsl = hwatch "kubectl get deployment --show-labels"
alias ksysgdepwsl = hwatch "kubectl --namespace=kube-system get deployment --show-labels"
alias kgstswsl = hwatch "kubectl get statefulset --show-labels"
alias ksysgstswsl = hwatch "kubectl --namespace=kube-system get statefulset --show-labels"
alias kgsvcwsl = hwatch "kubectl get service --show-labels"
alias ksysgsvcwsl = hwatch "kubectl --namespace=kube-system get service --show-labels"
alias kgingwsl = hwatch "kubectl get ingress --show-labels"
alias ksysgingwsl = hwatch "kubectl --namespace=kube-system get ingress --show-labels"
alias kgcmwsl = hwatch "kubectl get configmap --show-labels"
alias ksysgcmwsl = hwatch "kubectl --namespace=kube-system get configmap --show-labels"
alias kgsecwsl = hwatch "kubectl get secret --show-labels"
alias ksysgsecwsl = hwatch "kubectl --namespace=kube-system get secret --show-labels"
alias kgnowsl = hwatch "kubectl get nodes --show-labels"
alias kgnswsl = hwatch "kubectl get namespaces --show-labels"
alias kgallwoyaml = hwatch "kubectl get --all-namespaces -o=yaml"
alias kgpoallwoyaml = hwatch "kubectl get pods --all-namespaces -o=yaml"
alias kgdepallwoyaml = hwatch "kubectl get deployment --all-namespaces -o=yaml"
alias kgstsallwoyaml = hwatch "kubectl get statefulset --all-namespaces -o=yaml"
alias kgsvcallwoyaml = hwatch "kubectl get service --all-namespaces -o=yaml"
alias kgingallwoyaml = hwatch "kubectl get ingress --all-namespaces -o=yaml"
alias kgcmallwoyaml = hwatch "kubectl get configmap --all-namespaces -o=yaml"
alias kgsecallwoyaml = hwatch "kubectl get secret --all-namespaces -o=yaml"
alias kgnsallwoyaml = hwatch "kubectl get namespaces --all-namespaces -o=yaml"
alias kgwoyamlall = hwatch "kubectl get -o=yaml --all-namespaces"
alias kgpowoyamlall = hwatch "kubectl get pods -o=yaml --all-namespaces"
alias kgdepwoyamlall = hwatch "kubectl get deployment -o=yaml --all-namespaces"
alias kgstswoyamlall = hwatch "kubectl get statefulset -o=yaml --all-namespaces"
alias kgsvcwoyamlall = hwatch "kubectl get service -o=yaml --all-namespaces"
alias kgingwoyamlall = hwatch "kubectl get ingress -o=yaml --all-namespaces"
alias kgcmwoyamlall = hwatch "kubectl get configmap -o=yaml --all-namespaces"
alias kgsecwoyamlall = hwatch "kubectl get secret -o=yaml --all-namespaces"
alias kgnswoyamlall = hwatch "kubectl get namespaces -o=yaml --all-namespaces"
alias kgwalloyaml = hwatch "kubectl get --all-namespaces -o=yaml"
alias kgpowalloyaml = hwatch "kubectl get pods --all-namespaces -o=yaml"
alias kgdepwalloyaml = hwatch "kubectl get deployment --all-namespaces -o=yaml"
alias kgstswalloyaml = hwatch "kubectl get statefulset --all-namespaces -o=yaml"
alias kgsvcwalloyaml = hwatch "kubectl get service --all-namespaces -o=yaml"
alias kgingwalloyaml = hwatch "kubectl get ingress --all-namespaces -o=yaml"
alias kgcmwalloyaml = hwatch "kubectl get configmap --all-namespaces -o=yaml"
alias kgsecwalloyaml = hwatch "kubectl get secret --all-namespaces -o=yaml"
alias kgnswalloyaml = hwatch "kubectl get namespaces --all-namespaces -o=yaml"
alias kgowideallsl = kubectl get -o=wide --all-namespaces --show-labels
alias kgpoowideallsl = kubectl get pods -o=wide --all-namespaces --show-labels
alias kgdepowideallsl = kubectl get deployment -o=wide --all-namespaces --show-labels
alias kgstsowideallsl = kubectl get statefulset -o=wide --all-namespaces --show-labels
alias kgsvcowideallsl = kubectl get service -o=wide --all-namespaces --show-labels
alias kgingowideallsl = kubectl get ingress -o=wide --all-namespaces --show-labels
alias kgcmowideallsl = kubectl get configmap -o=wide --all-namespaces --show-labels
alias kgsecowideallsl = kubectl get secret -o=wide --all-namespaces --show-labels
alias kgnsowideallsl = kubectl get namespaces -o=wide --all-namespaces --show-labels
alias kgowideslall = kubectl get -o=wide --show-labels --all-namespaces
alias kgpoowideslall = kubectl get pods -o=wide --show-labels --all-namespaces
alias kgdepowideslall = kubectl get deployment -o=wide --show-labels --all-namespaces
alias kgstsowideslall = kubectl get statefulset -o=wide --show-labels --all-namespaces
alias kgsvcowideslall = kubectl get service -o=wide --show-labels --all-namespaces
alias kgingowideslall = kubectl get ingress -o=wide --show-labels --all-namespaces
alias kgcmowideslall = kubectl get configmap -o=wide --show-labels --all-namespaces
alias kgsecowideslall = kubectl get secret -o=wide --show-labels --all-namespaces
alias kgnsowideslall = kubectl get namespaces -o=wide --show-labels --all-namespaces
alias kgallowidesl = kubectl get --all-namespaces -o=wide --show-labels
alias kgpoallowidesl = kubectl get pods --all-namespaces -o=wide --show-labels
alias kgdepallowidesl = kubectl get deployment --all-namespaces -o=wide --show-labels
alias kgstsallowidesl = kubectl get statefulset --all-namespaces -o=wide --show-labels
alias kgsvcallowidesl = kubectl get service --all-namespaces -o=wide --show-labels
alias kgingallowidesl = kubectl get ingress --all-namespaces -o=wide --show-labels
alias kgcmallowidesl = kubectl get configmap --all-namespaces -o=wide --show-labels
alias kgsecallowidesl = kubectl get secret --all-namespaces -o=wide --show-labels
alias kgnsallowidesl = kubectl get namespaces --all-namespaces -o=wide --show-labels
alias kgallslowide = kubectl get --all-namespaces --show-labels -o=wide
alias kgpoallslowide = kubectl get pods --all-namespaces --show-labels -o=wide
alias kgdepallslowide = kubectl get deployment --all-namespaces --show-labels -o=wide
alias kgstsallslowide = kubectl get statefulset --all-namespaces --show-labels -o=wide
alias kgsvcallslowide = kubectl get service --all-namespaces --show-labels -o=wide
alias kgingallslowide = kubectl get ingress --all-namespaces --show-labels -o=wide
alias kgcmallslowide = kubectl get configmap --all-namespaces --show-labels -o=wide
alias kgsecallslowide = kubectl get secret --all-namespaces --show-labels -o=wide
alias kgnsallslowide = kubectl get namespaces --all-namespaces --show-labels -o=wide
alias kgslowideall = kubectl get --show-labels -o=wide --all-namespaces
alias kgposlowideall = kubectl get pods --show-labels -o=wide --all-namespaces
alias kgdepslowideall = kubectl get deployment --show-labels -o=wide --all-namespaces
alias kgstsslowideall = kubectl get statefulset --show-labels -o=wide --all-namespaces
alias kgsvcslowideall = kubectl get service --show-labels -o=wide --all-namespaces
alias kgingslowideall = kubectl get ingress --show-labels -o=wide --all-namespaces
alias kgcmslowideall = kubectl get configmap --show-labels -o=wide --all-namespaces
alias kgsecslowideall = kubectl get secret --show-labels -o=wide --all-namespaces
alias kgnsslowideall = kubectl get namespaces --show-labels -o=wide --all-namespaces
alias kgslallowide = kubectl get --show-labels --all-namespaces -o=wide
alias kgposlallowide = kubectl get pods --show-labels --all-namespaces -o=wide
alias kgdepslallowide = kubectl get deployment --show-labels --all-namespaces -o=wide
alias kgstsslallowide = kubectl get statefulset --show-labels --all-namespaces -o=wide
alias kgsvcslallowide = kubectl get service --show-labels --all-namespaces -o=wide
alias kgingslallowide = kubectl get ingress --show-labels --all-namespaces -o=wide
alias kgcmslallowide = kubectl get configmap --show-labels --all-namespaces -o=wide
alias kgsecslallowide = kubectl get secret --show-labels --all-namespaces -o=wide
alias kgnsslallowide = kubectl get namespaces --show-labels --all-namespaces -o=wide
alias kgallwowide = hwatch "kubectl get --all-namespaces -o=wide"
alias kgpoallwowide = hwatch "kubectl get pods --all-namespaces -o=wide"
alias kgdepallwowide = hwatch "kubectl get deployment --all-namespaces -o=wide"
alias kgstsallwowide = hwatch "kubectl get statefulset --all-namespaces -o=wide"
alias kgsvcallwowide = hwatch "kubectl get service --all-namespaces -o=wide"
alias kgingallwowide = hwatch "kubectl get ingress --all-namespaces -o=wide"
alias kgcmallwowide = hwatch "kubectl get configmap --all-namespaces -o=wide"
alias kgsecallwowide = hwatch "kubectl get secret --all-namespaces -o=wide"
alias kgnsallwowide = hwatch "kubectl get namespaces --all-namespaces -o=wide"
alias kgwowideall = hwatch "kubectl get -o=wide --all-namespaces"
alias kgpowowideall = hwatch "kubectl get pods -o=wide --all-namespaces"
alias kgdepwowideall = hwatch "kubectl get deployment -o=wide --all-namespaces"
alias kgstswowideall = hwatch "kubectl get statefulset -o=wide --all-namespaces"
alias kgsvcwowideall = hwatch "kubectl get service -o=wide --all-namespaces"
alias kgingwowideall = hwatch "kubectl get ingress -o=wide --all-namespaces"
alias kgcmwowideall = hwatch "kubectl get configmap -o=wide --all-namespaces"
alias kgsecwowideall = hwatch "kubectl get secret -o=wide --all-namespaces"
alias kgnswowideall = hwatch "kubectl get namespaces -o=wide --all-namespaces"
alias kgwallowide = hwatch "kubectl get --all-namespaces -o=wide"
alias kgpowallowide = hwatch "kubectl get pods --all-namespaces -o=wide"
alias kgdepwallowide = hwatch "kubectl get deployment --all-namespaces -o=wide"
alias kgstswallowide = hwatch "kubectl get statefulset --all-namespaces -o=wide"
alias kgsvcwallowide = hwatch "kubectl get service --all-namespaces -o=wide"
alias kgingwallowide = hwatch "kubectl get ingress --all-namespaces -o=wide"
alias kgcmwallowide = hwatch "kubectl get configmap --all-namespaces -o=wide"
alias kgsecwallowide = hwatch "kubectl get secret --all-namespaces -o=wide"
alias kgnswallowide = hwatch "kubectl get namespaces --all-namespaces -o=wide"
alias kgslwowide = hwatch "kubectl get --show-labels -o=wide"
alias ksysgslwowide = hwatch "kubectl --namespace=kube-system get --show-labels -o=wide"
alias kgposlwowide = hwatch "kubectl get pods --show-labels -o=wide"
alias ksysgposlwowide = hwatch "kubectl --namespace=kube-system get pods --show-labels -o=wide"
alias kgdepslwowide = hwatch "kubectl get deployment --show-labels -o=wide"
alias ksysgdepslwowide = hwatch "kubectl --namespace=kube-system get deployment --show-labels -o=wide"
alias kgstsslwowide = hwatch "kubectl get statefulset --show-labels -o=wide"
alias ksysgstsslwowide = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -o=wide"
alias kgsvcslwowide = hwatch "kubectl get service --show-labels -o=wide"
alias ksysgsvcslwowide = hwatch "kubectl --namespace=kube-system get service --show-labels -o=wide"
alias kgingslwowide = hwatch "kubectl get ingress --show-labels -o=wide"
alias ksysgingslwowide = hwatch "kubectl --namespace=kube-system get ingress --show-labels -o=wide"
alias kgcmslwowide = hwatch "kubectl get configmap --show-labels -o=wide"
alias ksysgcmslwowide = hwatch "kubectl --namespace=kube-system get configmap --show-labels -o=wide"
alias kgsecslwowide = hwatch "kubectl get secret --show-labels -o=wide"
alias ksysgsecslwowide = hwatch "kubectl --namespace=kube-system get secret --show-labels -o=wide"
alias kgnoslwowide = hwatch "kubectl get nodes --show-labels -o=wide"
alias kgnsslwowide = hwatch "kubectl get namespaces --show-labels -o=wide"
alias kgwowidesl = hwatch "kubectl get -o=wide --show-labels"
alias ksysgwowidesl = hwatch "kubectl --namespace=kube-system get -o=wide --show-labels"
alias kgpowowidesl = hwatch "kubectl get pods -o=wide --show-labels"
alias ksysgpowowidesl = hwatch "kubectl --namespace=kube-system get pods -o=wide --show-labels"
alias kgdepwowidesl = hwatch "kubectl get deployment -o=wide --show-labels"
alias ksysgdepwowidesl = hwatch "kubectl --namespace=kube-system get deployment -o=wide --show-labels"
alias kgstswowidesl = hwatch "kubectl get statefulset -o=wide --show-labels"
alias ksysgstswowidesl = hwatch "kubectl --namespace=kube-system get statefulset -o=wide --show-labels"
alias kgsvcwowidesl = hwatch "kubectl get service -o=wide --show-labels"
alias ksysgsvcwowidesl = hwatch "kubectl --namespace=kube-system get service -o=wide --show-labels"
alias kgingwowidesl = hwatch "kubectl get ingress -o=wide --show-labels"
alias ksysgingwowidesl = hwatch "kubectl --namespace=kube-system get ingress -o=wide --show-labels"
alias kgcmwowidesl = hwatch "kubectl get configmap -o=wide --show-labels"
alias ksysgcmwowidesl = hwatch "kubectl --namespace=kube-system get configmap -o=wide --show-labels"
alias kgsecwowidesl = hwatch "kubectl get secret -o=wide --show-labels"
alias ksysgsecwowidesl = hwatch "kubectl --namespace=kube-system get secret -o=wide --show-labels"
alias kgnowowidesl = hwatch "kubectl get nodes -o=wide --show-labels"
alias kgnswowidesl = hwatch "kubectl get namespaces -o=wide --show-labels"
alias kgwslowide = hwatch "kubectl get --show-labels -o=wide"
alias ksysgwslowide = hwatch "kubectl --namespace=kube-system get --show-labels -o=wide"
alias kgpowslowide = hwatch "kubectl get pods --show-labels -o=wide"
alias ksysgpowslowide = hwatch "kubectl --namespace=kube-system get pods --show-labels -o=wide"
alias kgdepwslowide = hwatch "kubectl get deployment --show-labels -o=wide"
alias ksysgdepwslowide = hwatch "kubectl --namespace=kube-system get deployment --show-labels -o=wide"
alias kgstswslowide = hwatch "kubectl get statefulset --show-labels -o=wide"
alias ksysgstswslowide = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -o=wide"
alias kgsvcwslowide = hwatch "kubectl get service --show-labels -o=wide"
alias ksysgsvcwslowide = hwatch "kubectl --namespace=kube-system get service --show-labels -o=wide"
alias kgingwslowide = hwatch "kubectl get ingress --show-labels -o=wide"
alias ksysgingwslowide = hwatch "kubectl --namespace=kube-system get ingress --show-labels -o=wide"
alias kgcmwslowide = hwatch "kubectl get configmap --show-labels -o=wide"
alias ksysgcmwslowide = hwatch "kubectl --namespace=kube-system get configmap --show-labels -o=wide"
alias kgsecwslowide = hwatch "kubectl get secret --show-labels -o=wide"
alias ksysgsecwslowide = hwatch "kubectl --namespace=kube-system get secret --show-labels -o=wide"
alias kgnowslowide = hwatch "kubectl get nodes --show-labels -o=wide"
alias kgnswslowide = hwatch "kubectl get namespaces --show-labels -o=wide"
alias kgallwojson = hwatch "kubectl get --all-namespaces -o=json"
alias kgpoallwojson = hwatch "kubectl get pods --all-namespaces -o=json"
alias kgdepallwojson = hwatch "kubectl get deployment --all-namespaces -o=json"
alias kgstsallwojson = hwatch "kubectl get statefulset --all-namespaces -o=json"
alias kgsvcallwojson = hwatch "kubectl get service --all-namespaces -o=json"
alias kgingallwojson = hwatch "kubectl get ingress --all-namespaces -o=json"
alias kgcmallwojson = hwatch "kubectl get configmap --all-namespaces -o=json"
alias kgsecallwojson = hwatch "kubectl get secret --all-namespaces -o=json"
alias kgnsallwojson = hwatch "kubectl get namespaces --all-namespaces -o=json"
alias kgwojsonall = hwatch "kubectl get -o=json --all-namespaces"
alias kgpowojsonall = hwatch "kubectl get pods -o=json --all-namespaces"
alias kgdepwojsonall = hwatch "kubectl get deployment -o=json --all-namespaces"
alias kgstswojsonall = hwatch "kubectl get statefulset -o=json --all-namespaces"
alias kgsvcwojsonall = hwatch "kubectl get service -o=json --all-namespaces"
alias kgingwojsonall = hwatch "kubectl get ingress -o=json --all-namespaces"
alias kgcmwojsonall = hwatch "kubectl get configmap -o=json --all-namespaces"
alias kgsecwojsonall = hwatch "kubectl get secret -o=json --all-namespaces"
alias kgnswojsonall = hwatch "kubectl get namespaces -o=json --all-namespaces"
alias kgwallojson = hwatch "kubectl get --all-namespaces -o=json"
alias kgpowallojson = hwatch "kubectl get pods --all-namespaces -o=json"
alias kgdepwallojson = hwatch "kubectl get deployment --all-namespaces -o=json"
alias kgstswallojson = hwatch "kubectl get statefulset --all-namespaces -o=json"
alias kgsvcwallojson = hwatch "kubectl get service --all-namespaces -o=json"
alias kgingwallojson = hwatch "kubectl get ingress --all-namespaces -o=json"
alias kgcmwallojson = hwatch "kubectl get configmap --all-namespaces -o=json"
alias kgsecwallojson = hwatch "kubectl get secret --all-namespaces -o=json"
alias kgnswallojson = hwatch "kubectl get namespaces --all-namespaces -o=json"
alias kgallslw = hwatch "kubectl get --all-namespaces --show-labels"
alias kgpoallslw = hwatch "kubectl get pods --all-namespaces --show-labels"
alias kgdepallslw = hwatch "kubectl get deployment --all-namespaces --show-labels"
alias kgstsallslw = hwatch "kubectl get statefulset --all-namespaces --show-labels"
alias kgsvcallslw = hwatch "kubectl get service --all-namespaces --show-labels"
alias kgingallslw = hwatch "kubectl get ingress --all-namespaces --show-labels"
alias kgcmallslw = hwatch "kubectl get configmap --all-namespaces --show-labels"
alias kgsecallslw = hwatch "kubectl get secret --all-namespaces --show-labels"
alias kgnsallslw = hwatch "kubectl get namespaces --all-namespaces --show-labels"
alias kgallwsl = hwatch "kubectl get --all-namespaces --show-labels"
alias kgpoallwsl = hwatch "kubectl get pods --all-namespaces --show-labels"
alias kgdepallwsl = hwatch "kubectl get deployment --all-namespaces --show-labels"
alias kgstsallwsl = hwatch "kubectl get statefulset --all-namespaces --show-labels"
alias kgsvcallwsl = hwatch "kubectl get service --all-namespaces --show-labels"
alias kgingallwsl = hwatch "kubectl get ingress --all-namespaces --show-labels"
alias kgcmallwsl = hwatch "kubectl get configmap --all-namespaces --show-labels"
alias kgsecallwsl = hwatch "kubectl get secret --all-namespaces --show-labels"
alias kgnsallwsl = hwatch "kubectl get namespaces --all-namespaces --show-labels"
alias kgslallw = hwatch "kubectl get --show-labels --all-namespaces"
alias kgposlallw = hwatch "kubectl get pods --show-labels --all-namespaces"
alias kgdepslallw = hwatch "kubectl get deployment --show-labels --all-namespaces"
alias kgstsslallw = hwatch "kubectl get statefulset --show-labels --all-namespaces"
alias kgsvcslallw = hwatch "kubectl get service --show-labels --all-namespaces"
alias kgingslallw = hwatch "kubectl get ingress --show-labels --all-namespaces"
alias kgcmslallw = hwatch "kubectl get configmap --show-labels --all-namespaces"
alias kgsecslallw = hwatch "kubectl get secret --show-labels --all-namespaces"
alias kgnsslallw = hwatch "kubectl get namespaces --show-labels --all-namespaces"
alias kgslwall = hwatch "kubectl get --show-labels --all-namespaces"
alias kgposlwall = hwatch "kubectl get pods --show-labels --all-namespaces"
alias kgdepslwall = hwatch "kubectl get deployment --show-labels --all-namespaces"
alias kgstsslwall = hwatch "kubectl get statefulset --show-labels --all-namespaces"
alias kgsvcslwall = hwatch "kubectl get service --show-labels --all-namespaces"
alias kgingslwall = hwatch "kubectl get ingress --show-labels --all-namespaces"
alias kgcmslwall = hwatch "kubectl get configmap --show-labels --all-namespaces"
alias kgsecslwall = hwatch "kubectl get secret --show-labels --all-namespaces"
alias kgnsslwall = hwatch "kubectl get namespaces --show-labels --all-namespaces"
alias kgwallsl = hwatch "kubectl get --all-namespaces --show-labels"
alias kgpowallsl = hwatch "kubectl get pods --all-namespaces --show-labels"
alias kgdepwallsl = hwatch "kubectl get deployment --all-namespaces --show-labels"
alias kgstswallsl = hwatch "kubectl get statefulset --all-namespaces --show-labels"
alias kgsvcwallsl = hwatch "kubectl get service --all-namespaces --show-labels"
alias kgingwallsl = hwatch "kubectl get ingress --all-namespaces --show-labels"
alias kgcmwallsl = hwatch "kubectl get configmap --all-namespaces --show-labels"
alias kgsecwallsl = hwatch "kubectl get secret --all-namespaces --show-labels"
alias kgnswallsl = hwatch "kubectl get namespaces --all-namespaces --show-labels"
alias kgwslall = hwatch "kubectl get --show-labels --all-namespaces"
alias kgpowslall = hwatch "kubectl get pods --show-labels --all-namespaces"
alias kgdepwslall = hwatch "kubectl get deployment --show-labels --all-namespaces"
alias kgstswslall = hwatch "kubectl get statefulset --show-labels --all-namespaces"
alias kgsvcwslall = hwatch "kubectl get service --show-labels --all-namespaces"
alias kgingwslall = hwatch "kubectl get ingress --show-labels --all-namespaces"
alias kgcmwslall = hwatch "kubectl get configmap --show-labels --all-namespaces"
alias kgsecwslall = hwatch "kubectl get secret --show-labels --all-namespaces"
alias kgnswslall = hwatch "kubectl get namespaces --show-labels --all-namespaces"
alias kgallslwowide = hwatch "kubectl get --all-namespaces --show-labels -o=wide"
alias kgpoallslwowide = hwatch "kubectl get pods --all-namespaces --show-labels -o=wide"
alias kgdepallslwowide = hwatch "kubectl get deployment --all-namespaces --show-labels -o=wide"
alias kgstsallslwowide = hwatch "kubectl get statefulset --all-namespaces --show-labels -o=wide"
alias kgsvcallslwowide = hwatch "kubectl get service --all-namespaces --show-labels -o=wide"
alias kgingallslwowide = hwatch "kubectl get ingress --all-namespaces --show-labels -o=wide"
alias kgcmallslwowide = hwatch "kubectl get configmap --all-namespaces --show-labels -o=wide"
alias kgsecallslwowide = hwatch "kubectl get secret --all-namespaces --show-labels -o=wide"
alias kgnsallslwowide = hwatch "kubectl get namespaces --all-namespaces --show-labels -o=wide"
alias kgallwowidesl = hwatch "kubectl get --all-namespaces -o=wide --show-labels"
alias kgpoallwowidesl = hwatch "kubectl get pods --all-namespaces -o=wide --show-labels"
alias kgdepallwowidesl = hwatch "kubectl get deployment --all-namespaces -o=wide --show-labels"
alias kgstsallwowidesl = hwatch "kubectl get statefulset --all-namespaces -o=wide --show-labels"
alias kgsvcallwowidesl = hwatch "kubectl get service --all-namespaces -o=wide --show-labels"
alias kgingallwowidesl = hwatch "kubectl get ingress --all-namespaces -o=wide --show-labels"
alias kgcmallwowidesl = hwatch "kubectl get configmap --all-namespaces -o=wide --show-labels"
alias kgsecallwowidesl = hwatch "kubectl get secret --all-namespaces -o=wide --show-labels"
alias kgnsallwowidesl = hwatch "kubectl get namespaces --all-namespaces -o=wide --show-labels"
alias kgallwslowide = hwatch "kubectl get --all-namespaces --show-labels -o=wide"
alias kgpoallwslowide = hwatch "kubectl get pods --all-namespaces --show-labels -o=wide"
alias kgdepallwslowide = hwatch "kubectl get deployment --all-namespaces --show-labels -o=wide"
alias kgstsallwslowide = hwatch "kubectl get statefulset --all-namespaces --show-labels -o=wide"
alias kgsvcallwslowide = hwatch "kubectl get service --all-namespaces --show-labels -o=wide"
alias kgingallwslowide = hwatch "kubectl get ingress --all-namespaces --show-labels -o=wide"
alias kgcmallwslowide = hwatch "kubectl get configmap --all-namespaces --show-labels -o=wide"
alias kgsecallwslowide = hwatch "kubectl get secret --all-namespaces --show-labels -o=wide"
alias kgnsallwslowide = hwatch "kubectl get namespaces --all-namespaces --show-labels -o=wide"
alias kgslallwowide = hwatch "kubectl get --show-labels --all-namespaces -o=wide"
alias kgposlallwowide = hwatch "kubectl get pods --show-labels --all-namespaces -o=wide"
alias kgdepslallwowide = hwatch "kubectl get deployment --show-labels --all-namespaces -o=wide"
alias kgstsslallwowide = hwatch "kubectl get statefulset --show-labels --all-namespaces -o=wide"
alias kgsvcslallwowide = hwatch "kubectl get service --show-labels --all-namespaces -o=wide"
alias kgingslallwowide = hwatch "kubectl get ingress --show-labels --all-namespaces -o=wide"
alias kgcmslallwowide = hwatch "kubectl get configmap --show-labels --all-namespaces -o=wide"
alias kgsecslallwowide = hwatch "kubectl get secret --show-labels --all-namespaces -o=wide"
alias kgnsslallwowide = hwatch "kubectl get namespaces --show-labels --all-namespaces -o=wide"
alias kgslwowideall = hwatch "kubectl get --show-labels -o=wide --all-namespaces"
alias kgposlwowideall = hwatch "kubectl get pods --show-labels -o=wide --all-namespaces"
alias kgdepslwowideall = hwatch "kubectl get deployment --show-labels -o=wide --all-namespaces"
alias kgstsslwowideall = hwatch "kubectl get statefulset --show-labels -o=wide --all-namespaces"
alias kgsvcslwowideall = hwatch "kubectl get service --show-labels -o=wide --all-namespaces"
alias kgingslwowideall = hwatch "kubectl get ingress --show-labels -o=wide --all-namespaces"
alias kgcmslwowideall = hwatch "kubectl get configmap --show-labels -o=wide --all-namespaces"
alias kgsecslwowideall = hwatch "kubectl get secret --show-labels -o=wide --all-namespaces"
alias kgnsslwowideall = hwatch "kubectl get namespaces --show-labels -o=wide --all-namespaces"
alias kgslwallowide = hwatch "kubectl get --show-labels --all-namespaces -o=wide"
alias kgposlwallowide = hwatch "kubectl get pods --show-labels --all-namespaces -o=wide"
alias kgdepslwallowide = hwatch "kubectl get deployment --show-labels --all-namespaces -o=wide"
alias kgstsslwallowide = hwatch "kubectl get statefulset --show-labels --all-namespaces -o=wide"
alias kgsvcslwallowide = hwatch "kubectl get service --show-labels --all-namespaces -o=wide"
alias kgingslwallowide = hwatch "kubectl get ingress --show-labels --all-namespaces -o=wide"
alias kgcmslwallowide = hwatch "kubectl get configmap --show-labels --all-namespaces -o=wide"
alias kgsecslwallowide = hwatch "kubectl get secret --show-labels --all-namespaces -o=wide"
alias kgnsslwallowide = hwatch "kubectl get namespaces --show-labels --all-namespaces -o=wide"
alias kgwowideallsl = hwatch "kubectl get -o=wide --all-namespaces --show-labels"
alias kgpowowideallsl = hwatch "kubectl get pods -o=wide --all-namespaces --show-labels"
alias kgdepwowideallsl = hwatch "kubectl get deployment -o=wide --all-namespaces --show-labels"
alias kgstswowideallsl = hwatch "kubectl get statefulset -o=wide --all-namespaces --show-labels"
alias kgsvcwowideallsl = hwatch "kubectl get service -o=wide --all-namespaces --show-labels"
alias kgingwowideallsl = hwatch "kubectl get ingress -o=wide --all-namespaces --show-labels"
alias kgcmwowideallsl = hwatch "kubectl get configmap -o=wide --all-namespaces --show-labels"
alias kgsecwowideallsl = hwatch "kubectl get secret -o=wide --all-namespaces --show-labels"
alias kgnswowideallsl = hwatch "kubectl get namespaces -o=wide --all-namespaces --show-labels"
alias kgwowideslall = hwatch "kubectl get -o=wide --show-labels --all-namespaces"
alias kgpowowideslall = hwatch "kubectl get pods -o=wide --show-labels --all-namespaces"
alias kgdepwowideslall = hwatch "kubectl get deployment -o=wide --show-labels --all-namespaces"
alias kgstswowideslall = hwatch "kubectl get statefulset -o=wide --show-labels --all-namespaces"
alias kgsvcwowideslall = hwatch "kubectl get service -o=wide --show-labels --all-namespaces"
alias kgingwowideslall = hwatch "kubectl get ingress -o=wide --show-labels --all-namespaces"
alias kgcmwowideslall = hwatch "kubectl get configmap -o=wide --show-labels --all-namespaces"
alias kgsecwowideslall = hwatch "kubectl get secret -o=wide --show-labels --all-namespaces"
alias kgnswowideslall = hwatch "kubectl get namespaces -o=wide --show-labels --all-namespaces"
alias kgwallowidesl = hwatch "kubectl get --all-namespaces -o=wide --show-labels"
alias kgpowallowidesl = hwatch "kubectl get pods --all-namespaces -o=wide --show-labels"
alias kgdepwallowidesl = hwatch "kubectl get deployment --all-namespaces -o=wide --show-labels"
alias kgstswallowidesl = hwatch "kubectl get statefulset --all-namespaces -o=wide --show-labels"
alias kgsvcwallowidesl = hwatch "kubectl get service --all-namespaces -o=wide --show-labels"
alias kgingwallowidesl = hwatch "kubectl get ingress --all-namespaces -o=wide --show-labels"
alias kgcmwallowidesl = hwatch "kubectl get configmap --all-namespaces -o=wide --show-labels"
alias kgsecwallowidesl = hwatch "kubectl get secret --all-namespaces -o=wide --show-labels"
alias kgnswallowidesl = hwatch "kubectl get namespaces --all-namespaces -o=wide --show-labels"
alias kgwallslowide = hwatch "kubectl get --all-namespaces --show-labels -o=wide"
alias kgpowallslowide = hwatch "kubectl get pods --all-namespaces --show-labels -o=wide"
alias kgdepwallslowide = hwatch "kubectl get deployment --all-namespaces --show-labels -o=wide"
alias kgstswallslowide = hwatch "kubectl get statefulset --all-namespaces --show-labels -o=wide"
alias kgsvcwallslowide = hwatch "kubectl get service --all-namespaces --show-labels -o=wide"
alias kgingwallslowide = hwatch "kubectl get ingress --all-namespaces --show-labels -o=wide"
alias kgcmwallslowide = hwatch "kubectl get configmap --all-namespaces --show-labels -o=wide"
alias kgsecwallslowide = hwatch "kubectl get secret --all-namespaces --show-labels -o=wide"
alias kgnswallslowide = hwatch "kubectl get namespaces --all-namespaces --show-labels -o=wide"
alias kgwslowideall = hwatch "kubectl get --show-labels -o=wide --all-namespaces"
alias kgpowslowideall = hwatch "kubectl get pods --show-labels -o=wide --all-namespaces"
alias kgdepwslowideall = hwatch "kubectl get deployment --show-labels -o=wide --all-namespaces"
alias kgstswslowideall = hwatch "kubectl get statefulset --show-labels -o=wide --all-namespaces"
alias kgsvcwslowideall = hwatch "kubectl get service --show-labels -o=wide --all-namespaces"
alias kgingwslowideall = hwatch "kubectl get ingress --show-labels -o=wide --all-namespaces"
alias kgcmwslowideall = hwatch "kubectl get configmap --show-labels -o=wide --all-namespaces"
alias kgsecwslowideall = hwatch "kubectl get secret --show-labels -o=wide --all-namespaces"
alias kgnswslowideall = hwatch "kubectl get namespaces --show-labels -o=wide --all-namespaces"
alias kgwslallowide = hwatch "kubectl get --show-labels --all-namespaces -o=wide"
alias kgpowslallowide = hwatch "kubectl get pods --show-labels --all-namespaces -o=wide"
alias kgdepwslallowide = hwatch "kubectl get deployment --show-labels --all-namespaces -o=wide"
alias kgstswslallowide = hwatch "kubectl get statefulset --show-labels --all-namespaces -o=wide"
alias kgsvcwslallowide = hwatch "kubectl get service --show-labels --all-namespaces -o=wide"
alias kgingwslallowide = hwatch "kubectl get ingress --show-labels --all-namespaces -o=wide"
alias kgcmwslallowide = hwatch "kubectl get configmap --show-labels --all-namespaces -o=wide"
alias kgsecwslallowide = hwatch "kubectl get secret --show-labels --all-namespaces -o=wide"
alias kgnswslallowide = hwatch "kubectl get namespaces --show-labels --all-namespaces -o=wide"
alias kgf = kubectl get --recursive -f
alias kdf = kubectl describe --recursive -f
alias krmf = kubectl delete --recursive -f
alias kgoyamlf = kubectl get -o=yaml --recursive -f
alias kgowidef = kubectl get -o=wide --recursive -f
alias kgojsonf = kubectl get -o=json --recursive -f
alias kgslf = kubectl get --show-labels --recursive -f
alias kgwf = hwatch "kubectl get --recursive -f"
alias kgwoyamlf = hwatch "kubectl get -o=yaml --recursive -f"
alias kgowideslf = kubectl get -o=wide --show-labels --recursive -f
alias kgslowidef = kubectl get --show-labels -o=wide --recursive -f
alias kgwowidef = hwatch "kubectl get -o=wide --recursive -f"
alias kgwojsonf = hwatch "kubectl get -o=json --recursive -f"
alias kgslwf = hwatch "kubectl get --show-labels --recursive -f"
alias kgwslf = hwatch "kubectl get --show-labels --recursive -f"
alias kgslwowidef = hwatch "kubectl get --show-labels -o=wide --recursive -f"
alias kgwowideslf = hwatch "kubectl get -o=wide --show-labels --recursive -f"
alias kgwslowidef = hwatch "kubectl get --show-labels -o=wide --recursive -f"
alias kgl = kubectl get -l
alias ksysgl = kubectl --namespace=kube-system get -l
alias kdl = kubectl describe -l
alias ksysdl = kubectl --namespace=kube-system describe -l
alias krml = kubectl delete -l
alias ksysrml = kubectl --namespace=kube-system delete -l
alias kgpol = kubectl get pods -l
alias ksysgpol = kubectl --namespace=kube-system get pods -l
alias kdpol = kubectl describe pods -l
alias ksysdpol = kubectl --namespace=kube-system describe pods -l
alias krmpol = kubectl delete pods -l
alias ksysrmpol = kubectl --namespace=kube-system delete pods -l
alias kgdepl = kubectl get deployment -l
alias ksysgdepl = kubectl --namespace=kube-system get deployment -l
alias kddepl = kubectl describe deployment -l
alias ksysddepl = kubectl --namespace=kube-system describe deployment -l
alias krmdepl = kubectl delete deployment -l
alias ksysrmdepl = kubectl --namespace=kube-system delete deployment -l
alias kgstsl = kubectl get statefulset -l
alias ksysgstsl = kubectl --namespace=kube-system get statefulset -l
alias kdstsl = kubectl describe statefulset -l
alias ksysdstsl = kubectl --namespace=kube-system describe statefulset -l
alias krmstsl = kubectl delete statefulset -l
alias ksysrmstsl = kubectl --namespace=kube-system delete statefulset -l
alias kgsvcl = kubectl get service -l
alias ksysgsvcl = kubectl --namespace=kube-system get service -l
alias kdsvcl = kubectl describe service -l
alias ksysdsvcl = kubectl --namespace=kube-system describe service -l
alias krmsvcl = kubectl delete service -l
alias ksysrmsvcl = kubectl --namespace=kube-system delete service -l
alias kgingl = kubectl get ingress -l
alias ksysgingl = kubectl --namespace=kube-system get ingress -l
alias kdingl = kubectl describe ingress -l
alias ksysdingl = kubectl --namespace=kube-system describe ingress -l
alias krmingl = kubectl delete ingress -l
alias ksysrmingl = kubectl --namespace=kube-system delete ingress -l
alias kgcml = kubectl get configmap -l
alias ksysgcml = kubectl --namespace=kube-system get configmap -l
alias kdcml = kubectl describe configmap -l
alias ksysdcml = kubectl --namespace=kube-system describe configmap -l
alias krmcml = kubectl delete configmap -l
alias ksysrmcml = kubectl --namespace=kube-system delete configmap -l
alias kgsecl = kubectl get secret -l
alias ksysgsecl = kubectl --namespace=kube-system get secret -l
alias kdsecl = kubectl describe secret -l
alias ksysdsecl = kubectl --namespace=kube-system describe secret -l
alias krmsecl = kubectl delete secret -l
alias ksysrmsecl = kubectl --namespace=kube-system delete secret -l
alias kgnol = kubectl get nodes -l
alias kdnol = kubectl describe nodes -l
alias kgnsl = kubectl get namespaces -l
alias kdnsl = kubectl describe namespaces -l
alias krmnsl = kubectl delete namespaces -l
alias kgoyamll = kubectl get -o=yaml -l
alias ksysgoyamll = kubectl --namespace=kube-system get -o=yaml -l
alias kgpooyamll = kubectl get pods -o=yaml -l
alias ksysgpooyamll = kubectl --namespace=kube-system get pods -o=yaml -l
alias kgdepoyamll = kubectl get deployment -o=yaml -l
alias ksysgdepoyamll = kubectl --namespace=kube-system get deployment -o=yaml -l
alias kgstsoyamll = kubectl get statefulset -o=yaml -l
alias ksysgstsoyamll = kubectl --namespace=kube-system get statefulset -o=yaml -l
alias kgsvcoyamll = kubectl get service -o=yaml -l
alias ksysgsvcoyamll = kubectl --namespace=kube-system get service -o=yaml -l
alias kgingoyamll = kubectl get ingress -o=yaml -l
alias ksysgingoyamll = kubectl --namespace=kube-system get ingress -o=yaml -l
alias kgcmoyamll = kubectl get configmap -o=yaml -l
alias ksysgcmoyamll = kubectl --namespace=kube-system get configmap -o=yaml -l
alias kgsecoyamll = kubectl get secret -o=yaml -l
alias ksysgsecoyamll = kubectl --namespace=kube-system get secret -o=yaml -l
alias kgnooyamll = kubectl get nodes -o=yaml -l
alias kgnsoyamll = kubectl get namespaces -o=yaml -l
alias kgowidel = kubectl get -o=wide -l
alias ksysgowidel = kubectl --namespace=kube-system get -o=wide -l
alias kgpoowidel = kubectl get pods -o=wide -l
alias ksysgpoowidel = kubectl --namespace=kube-system get pods -o=wide -l
alias kgdepowidel = kubectl get deployment -o=wide -l
alias ksysgdepowidel = kubectl --namespace=kube-system get deployment -o=wide -l
alias kgstsowidel = kubectl get statefulset -o=wide -l
alias ksysgstsowidel = kubectl --namespace=kube-system get statefulset -o=wide -l
alias kgsvcowidel = kubectl get service -o=wide -l
alias ksysgsvcowidel = kubectl --namespace=kube-system get service -o=wide -l
alias kgingowidel = kubectl get ingress -o=wide -l
alias ksysgingowidel = kubectl --namespace=kube-system get ingress -o=wide -l
alias kgcmowidel = kubectl get configmap -o=wide -l
alias ksysgcmowidel = kubectl --namespace=kube-system get configmap -o=wide -l
alias kgsecowidel = kubectl get secret -o=wide -l
alias ksysgsecowidel = kubectl --namespace=kube-system get secret -o=wide -l
alias kgnoowidel = kubectl get nodes -o=wide -l
alias kgnsowidel = kubectl get namespaces -o=wide -l
alias kgojsonl = kubectl get -o=json -l
alias ksysgojsonl = kubectl --namespace=kube-system get -o=json -l
alias kgpoojsonl = kubectl get pods -o=json -l
alias ksysgpoojsonl = kubectl --namespace=kube-system get pods -o=json -l
alias kgdepojsonl = kubectl get deployment -o=json -l
alias ksysgdepojsonl = kubectl --namespace=kube-system get deployment -o=json -l
alias kgstsojsonl = kubectl get statefulset -o=json -l
alias ksysgstsojsonl = kubectl --namespace=kube-system get statefulset -o=json -l
alias kgsvcojsonl = kubectl get service -o=json -l
alias ksysgsvcojsonl = kubectl --namespace=kube-system get service -o=json -l
alias kgingojsonl = kubectl get ingress -o=json -l
alias ksysgingojsonl = kubectl --namespace=kube-system get ingress -o=json -l
alias kgcmojsonl = kubectl get configmap -o=json -l
alias ksysgcmojsonl = kubectl --namespace=kube-system get configmap -o=json -l
alias kgsecojsonl = kubectl get secret -o=json -l
alias ksysgsecojsonl = kubectl --namespace=kube-system get secret -o=json -l
alias kgnoojsonl = kubectl get nodes -o=json -l
alias kgnsojsonl = kubectl get namespaces -o=json -l
alias kgsll = kubectl get --show-labels -l
alias ksysgsll = kubectl --namespace=kube-system get --show-labels -l
alias kgposll = kubectl get pods --show-labels -l
alias ksysgposll = kubectl --namespace=kube-system get pods --show-labels -l
alias kgdepsll = kubectl get deployment --show-labels -l
alias ksysgdepsll = kubectl --namespace=kube-system get deployment --show-labels -l
alias kgstssll = kubectl get statefulset --show-labels -l
alias ksysgstssll = kubectl --namespace=kube-system get statefulset --show-labels -l
alias kgsvcsll = kubectl get service --show-labels -l
alias ksysgsvcsll = kubectl --namespace=kube-system get service --show-labels -l
alias kgingsll = kubectl get ingress --show-labels -l
alias ksysgingsll = kubectl --namespace=kube-system get ingress --show-labels -l
alias kgcmsll = kubectl get configmap --show-labels -l
alias ksysgcmsll = kubectl --namespace=kube-system get configmap --show-labels -l
alias kgsecsll = kubectl get secret --show-labels -l
alias ksysgsecsll = kubectl --namespace=kube-system get secret --show-labels -l
alias kgnosll = kubectl get nodes --show-labels -l
alias kgnssll = kubectl get namespaces --show-labels -l
alias kgwl = hwatch "kubectl get -l"
alias ksysgwl = hwatch "kubectl --namespace=kube-system get -l"
alias kgpowl = hwatch "kubectl get pods -l"
alias ksysgpowl = hwatch "kubectl --namespace=kube-system get pods -l"
alias kgdepwl = hwatch "kubectl get deployment -l"
alias ksysgdepwl = hwatch "kubectl --namespace=kube-system get deployment -l"
alias kgstswl = hwatch "kubectl get statefulset -l"
alias ksysgstswl = hwatch "kubectl --namespace=kube-system get statefulset -l"
alias kgsvcwl = hwatch "kubectl get service -l"
alias ksysgsvcwl = hwatch "kubectl --namespace=kube-system get service -l"
alias kgingwl = hwatch "kubectl get ingress -l"
alias ksysgingwl = hwatch "kubectl --namespace=kube-system get ingress -l"
alias kgcmwl = hwatch "kubectl get configmap -l"
alias ksysgcmwl = hwatch "kubectl --namespace=kube-system get configmap -l"
alias kgsecwl = hwatch "kubectl get secret -l"
alias ksysgsecwl = hwatch "kubectl --namespace=kube-system get secret -l"
alias kgnowl = hwatch "kubectl get nodes -l"
alias kgnswl = hwatch "kubectl get namespaces -l"
alias kgwoyamll = hwatch "kubectl get -o=yaml -l"
alias ksysgwoyamll = hwatch "kubectl --namespace=kube-system get -o=yaml -l"
alias kgpowoyamll = hwatch "kubectl get pods -o=yaml -l"
alias ksysgpowoyamll = hwatch "kubectl --namespace=kube-system get pods -o=yaml -l"
alias kgdepwoyamll = hwatch "kubectl get deployment -o=yaml -l"
alias ksysgdepwoyamll = hwatch "kubectl --namespace=kube-system get deployment -o=yaml -l"
alias kgstswoyamll = hwatch "kubectl get statefulset -o=yaml -l"
alias ksysgstswoyamll = hwatch "kubectl --namespace=kube-system get statefulset -o=yaml -l"
alias kgsvcwoyamll = hwatch "kubectl get service -o=yaml -l"
alias ksysgsvcwoyamll = hwatch "kubectl --namespace=kube-system get service -o=yaml -l"
alias kgingwoyamll = hwatch "kubectl get ingress -o=yaml -l"
alias ksysgingwoyamll = hwatch "kubectl --namespace=kube-system get ingress -o=yaml -l"
alias kgcmwoyamll = hwatch "kubectl get configmap -o=yaml -l"
alias ksysgcmwoyamll = hwatch "kubectl --namespace=kube-system get configmap -o=yaml -l"
alias kgsecwoyamll = hwatch "kubectl get secret -o=yaml -l"
alias ksysgsecwoyamll = hwatch "kubectl --namespace=kube-system get secret -o=yaml -l"
alias kgnowoyamll = hwatch "kubectl get nodes -o=yaml -l"
alias kgnswoyamll = hwatch "kubectl get namespaces -o=yaml -l"
alias kgowidesll = kubectl get -o=wide --show-labels -l
alias ksysgowidesll = kubectl --namespace=kube-system get -o=wide --show-labels -l
alias kgpoowidesll = kubectl get pods -o=wide --show-labels -l
alias ksysgpoowidesll = kubectl --namespace=kube-system get pods -o=wide --show-labels -l
alias kgdepowidesll = kubectl get deployment -o=wide --show-labels -l
alias ksysgdepowidesll = kubectl --namespace=kube-system get deployment -o=wide --show-labels -l
alias kgstsowidesll = kubectl get statefulset -o=wide --show-labels -l
alias ksysgstsowidesll = kubectl --namespace=kube-system get statefulset -o=wide --show-labels -l
alias kgsvcowidesll = kubectl get service -o=wide --show-labels -l
alias ksysgsvcowidesll = kubectl --namespace=kube-system get service -o=wide --show-labels -l
alias kgingowidesll = kubectl get ingress -o=wide --show-labels -l
alias ksysgingowidesll = kubectl --namespace=kube-system get ingress -o=wide --show-labels -l
alias kgcmowidesll = kubectl get configmap -o=wide --show-labels -l
alias ksysgcmowidesll = kubectl --namespace=kube-system get configmap -o=wide --show-labels -l
alias kgsecowidesll = kubectl get secret -o=wide --show-labels -l
alias ksysgsecowidesll = kubectl --namespace=kube-system get secret -o=wide --show-labels -l
alias kgnoowidesll = kubectl get nodes -o=wide --show-labels -l
alias kgnsowidesll = kubectl get namespaces -o=wide --show-labels -l
alias kgslowidel = kubectl get --show-labels -o=wide -l
alias ksysgslowidel = kubectl --namespace=kube-system get --show-labels -o=wide -l
alias kgposlowidel = kubectl get pods --show-labels -o=wide -l
alias ksysgposlowidel = kubectl --namespace=kube-system get pods --show-labels -o=wide -l
alias kgdepslowidel = kubectl get deployment --show-labels -o=wide -l
alias ksysgdepslowidel = kubectl --namespace=kube-system get deployment --show-labels -o=wide -l
alias kgstsslowidel = kubectl get statefulset --show-labels -o=wide -l
alias ksysgstsslowidel = kubectl --namespace=kube-system get statefulset --show-labels -o=wide -l
alias kgsvcslowidel = kubectl get service --show-labels -o=wide -l
alias ksysgsvcslowidel = kubectl --namespace=kube-system get service --show-labels -o=wide -l
alias kgingslowidel = kubectl get ingress --show-labels -o=wide -l
alias ksysgingslowidel = kubectl --namespace=kube-system get ingress --show-labels -o=wide -l
alias kgcmslowidel = kubectl get configmap --show-labels -o=wide -l
alias ksysgcmslowidel = kubectl --namespace=kube-system get configmap --show-labels -o=wide -l
alias kgsecslowidel = kubectl get secret --show-labels -o=wide -l
alias ksysgsecslowidel = kubectl --namespace=kube-system get secret --show-labels -o=wide -l
alias kgnoslowidel = kubectl get nodes --show-labels -o=wide -l
alias kgnsslowidel = kubectl get namespaces --show-labels -o=wide -l
alias kgwowidel = hwatch "kubectl get -o=wide -l"
alias ksysgwowidel = hwatch "kubectl --namespace=kube-system get -o=wide -l"
alias kgpowowidel = hwatch "kubectl get pods -o=wide -l"
alias ksysgpowowidel = hwatch "kubectl --namespace=kube-system get pods -o=wide -l"
alias kgdepwowidel = hwatch "kubectl get deployment -o=wide -l"
alias ksysgdepwowidel = hwatch "kubectl --namespace=kube-system get deployment -o=wide -l"
alias kgstswowidel = hwatch "kubectl get statefulset -o=wide -l"
alias ksysgstswowidel = hwatch "kubectl --namespace=kube-system get statefulset -o=wide -l"
alias kgsvcwowidel = hwatch "kubectl get service -o=wide -l"
alias ksysgsvcwowidel = hwatch "kubectl --namespace=kube-system get service -o=wide -l"
alias kgingwowidel = hwatch "kubectl get ingress -o=wide -l"
alias ksysgingwowidel = hwatch "kubectl --namespace=kube-system get ingress -o=wide -l"
alias kgcmwowidel = hwatch "kubectl get configmap -o=wide -l"
alias ksysgcmwowidel = hwatch "kubectl --namespace=kube-system get configmap -o=wide -l"
alias kgsecwowidel = hwatch "kubectl get secret -o=wide -l"
alias ksysgsecwowidel = hwatch "kubectl --namespace=kube-system get secret -o=wide -l"
alias kgnowowidel = hwatch "kubectl get nodes -o=wide -l"
alias kgnswowidel = hwatch "kubectl get namespaces -o=wide -l"
alias kgwojsonl = hwatch "kubectl get -o=json -l"
alias ksysgwojsonl = hwatch "kubectl --namespace=kube-system get -o=json -l"
alias kgpowojsonl = hwatch "kubectl get pods -o=json -l"
alias ksysgpowojsonl = hwatch "kubectl --namespace=kube-system get pods -o=json -l"
alias kgdepwojsonl = hwatch "kubectl get deployment -o=json -l"
alias ksysgdepwojsonl = hwatch "kubectl --namespace=kube-system get deployment -o=json -l"
alias kgstswojsonl = hwatch "kubectl get statefulset -o=json -l"
alias ksysgstswojsonl = hwatch "kubectl --namespace=kube-system get statefulset -o=json -l"
alias kgsvcwojsonl = hwatch "kubectl get service -o=json -l"
alias ksysgsvcwojsonl = hwatch "kubectl --namespace=kube-system get service -o=json -l"
alias kgingwojsonl = hwatch "kubectl get ingress -o=json -l"
alias ksysgingwojsonl = hwatch "kubectl --namespace=kube-system get ingress -o=json -l"
alias kgcmwojsonl = hwatch "kubectl get configmap -o=json -l"
alias ksysgcmwojsonl = hwatch "kubectl --namespace=kube-system get configmap -o=json -l"
alias kgsecwojsonl = hwatch "kubectl get secret -o=json -l"
alias ksysgsecwojsonl = hwatch "kubectl --namespace=kube-system get secret -o=json -l"
alias kgnowojsonl = hwatch "kubectl get nodes -o=json -l"
alias kgnswojsonl = hwatch "kubectl get namespaces -o=json -l"
alias kgslwl = hwatch "kubectl get --show-labels -l"
alias ksysgslwl = hwatch "kubectl --namespace=kube-system get --show-labels -l"
alias kgposlwl = hwatch "kubectl get pods --show-labels -l"
alias ksysgposlwl = hwatch "kubectl --namespace=kube-system get pods --show-labels -l"
alias kgdepslwl = hwatch "kubectl get deployment --show-labels -l"
alias ksysgdepslwl = hwatch "kubectl --namespace=kube-system get deployment --show-labels -l"
alias kgstsslwl = hwatch "kubectl get statefulset --show-labels -l"
alias ksysgstsslwl = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -l"
alias kgsvcslwl = hwatch "kubectl get service --show-labels -l"
alias ksysgsvcslwl = hwatch "kubectl --namespace=kube-system get service --show-labels -l"
alias kgingslwl = hwatch "kubectl get ingress --show-labels -l"
alias ksysgingslwl = hwatch "kubectl --namespace=kube-system get ingress --show-labels -l"
alias kgcmslwl = hwatch "kubectl get configmap --show-labels -l"
alias ksysgcmslwl = hwatch "kubectl --namespace=kube-system get configmap --show-labels -l"
alias kgsecslwl = hwatch "kubectl get secret --show-labels -l"
alias ksysgsecslwl = hwatch "kubectl --namespace=kube-system get secret --show-labels -l"
alias kgnoslwl = hwatch "kubectl get nodes --show-labels -l"
alias kgnsslwl = hwatch "kubectl get namespaces --show-labels -l"
alias kgwsll = hwatch "kubectl get --show-labels -l"
alias ksysgwsll = hwatch "kubectl --namespace=kube-system get --show-labels -l"
alias kgpowsll = hwatch "kubectl get pods --show-labels -l"
alias ksysgpowsll = hwatch "kubectl --namespace=kube-system get pods --show-labels -l"
alias kgdepwsll = hwatch "kubectl get deployment --show-labels -l"
alias ksysgdepwsll = hwatch "kubectl --namespace=kube-system get deployment --show-labels -l"
alias kgstswsll = hwatch "kubectl get statefulset --show-labels -l"
alias ksysgstswsll = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -l"
alias kgsvcwsll = hwatch "kubectl get service --show-labels -l"
alias ksysgsvcwsll = hwatch "kubectl --namespace=kube-system get service --show-labels -l"
alias kgingwsll = hwatch "kubectl get ingress --show-labels -l"
alias ksysgingwsll = hwatch "kubectl --namespace=kube-system get ingress --show-labels -l"
alias kgcmwsll = hwatch "kubectl get configmap --show-labels -l"
alias ksysgcmwsll = hwatch "kubectl --namespace=kube-system get configmap --show-labels -l"
alias kgsecwsll = hwatch "kubectl get secret --show-labels -l"
alias ksysgsecwsll = hwatch "kubectl --namespace=kube-system get secret --show-labels -l"
alias kgnowsll = hwatch "kubectl get nodes --show-labels -l"
alias kgnswsll = hwatch "kubectl get namespaces --show-labels -l"
alias kgslwowidel = hwatch "kubectl get --show-labels -o=wide -l"
alias ksysgslwowidel = hwatch "kubectl --namespace=kube-system get --show-labels -o=wide -l"
alias kgposlwowidel = hwatch "kubectl get pods --show-labels -o=wide -l"
alias ksysgposlwowidel = hwatch "kubectl --namespace=kube-system get pods --show-labels -o=wide -l"
alias kgdepslwowidel = hwatch "kubectl get deployment --show-labels -o=wide -l"
alias ksysgdepslwowidel = hwatch "kubectl --namespace=kube-system get deployment --show-labels -o=wide -l"
alias kgstsslwowidel = hwatch "kubectl get statefulset --show-labels -o=wide -l"
alias ksysgstsslwowidel = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -o=wide -l"
alias kgsvcslwowidel = hwatch "kubectl get service --show-labels -o=wide -l"
alias ksysgsvcslwowidel = hwatch "kubectl --namespace=kube-system get service --show-labels -o=wide -l"
alias kgingslwowidel = hwatch "kubectl get ingress --show-labels -o=wide -l"
alias ksysgingslwowidel = hwatch "kubectl --namespace=kube-system get ingress --show-labels -o=wide -l"
alias kgcmslwowidel = hwatch "kubectl get configmap --show-labels -o=wide -l"
alias ksysgcmslwowidel = hwatch "kubectl --namespace=kube-system get configmap --show-labels -o=wide -l"
alias kgsecslwowidel = hwatch "kubectl get secret --show-labels -o=wide -l"
alias ksysgsecslwowidel = hwatch "kubectl --namespace=kube-system get secret --show-labels -o=wide -l"
alias kgnoslwowidel = hwatch "kubectl get nodes --show-labels -o=wide -l"
alias kgnsslwowidel = hwatch "kubectl get namespaces --show-labels -o=wide -l"
alias kgwowidesll = hwatch "kubectl get -o=wide --show-labels -l"
alias ksysgwowidesll = hwatch "kubectl --namespace=kube-system get -o=wide --show-labels -l"
alias kgpowowidesll = hwatch "kubectl get pods -o=wide --show-labels -l"
alias ksysgpowowidesll = hwatch "kubectl --namespace=kube-system get pods -o=wide --show-labels -l"
alias kgdepwowidesll = hwatch "kubectl get deployment -o=wide --show-labels -l"
alias ksysgdepwowidesll = hwatch "kubectl --namespace=kube-system get deployment -o=wide --show-labels -l"
alias kgstswowidesll = hwatch "kubectl get statefulset -o=wide --show-labels -l"
alias ksysgstswowidesll = hwatch "kubectl --namespace=kube-system get statefulset -o=wide --show-labels -l"
alias kgsvcwowidesll = hwatch "kubectl get service -o=wide --show-labels -l"
alias ksysgsvcwowidesll = hwatch "kubectl --namespace=kube-system get service -o=wide --show-labels -l"
alias kgingwowidesll = hwatch "kubectl get ingress -o=wide --show-labels -l"
alias ksysgingwowidesll = hwatch "kubectl --namespace=kube-system get ingress -o=wide --show-labels -l"
alias kgcmwowidesll = hwatch "kubectl get configmap -o=wide --show-labels -l"
alias ksysgcmwowidesll = hwatch "kubectl --namespace=kube-system get configmap -o=wide --show-labels -l"
alias kgsecwowidesll = hwatch "kubectl get secret -o=wide --show-labels -l"
alias ksysgsecwowidesll = hwatch "kubectl --namespace=kube-system get secret -o=wide --show-labels -l"
alias kgnowowidesll = hwatch "kubectl get nodes -o=wide --show-labels -l"
alias kgnswowidesll = hwatch "kubectl get namespaces -o=wide --show-labels -l"
alias kgwslowidel = hwatch "kubectl get --show-labels -o=wide -l"
alias ksysgwslowidel = hwatch "kubectl --namespace=kube-system get --show-labels -o=wide -l"
alias kgpowslowidel = hwatch "kubectl get pods --show-labels -o=wide -l"
alias ksysgpowslowidel = hwatch "kubectl --namespace=kube-system get pods --show-labels -o=wide -l"
alias kgdepwslowidel = hwatch "kubectl get deployment --show-labels -o=wide -l"
alias ksysgdepwslowidel = hwatch "kubectl --namespace=kube-system get deployment --show-labels -o=wide -l"
alias kgstswslowidel = hwatch "kubectl get statefulset --show-labels -o=wide -l"
alias ksysgstswslowidel = hwatch "kubectl --namespace=kube-system get statefulset --show-labels -o=wide -l"
alias kgsvcwslowidel = hwatch "kubectl get service --show-labels -o=wide -l"
alias ksysgsvcwslowidel = hwatch "kubectl --namespace=kube-system get service --show-labels -o=wide -l"
alias kgingwslowidel = hwatch "kubectl get ingress --show-labels -o=wide -l"
alias ksysgingwslowidel = hwatch "kubectl --namespace=kube-system get ingress --show-labels -o=wide -l"
alias kgcmwslowidel = hwatch "kubectl get configmap --show-labels -o=wide -l"
alias ksysgcmwslowidel = hwatch "kubectl --namespace=kube-system get configmap --show-labels -o=wide -l"
alias kgsecwslowidel = hwatch "kubectl get secret --show-labels -o=wide -l"
alias ksysgsecwslowidel = hwatch "kubectl --namespace=kube-system get secret --show-labels -o=wide -l"
alias kgnowslowidel = hwatch "kubectl get nodes --show-labels -o=wide -l"
alias kgnswslowidel = hwatch "kubectl get namespaces --show-labels -o=wide -l"
alias kexn = kubectl exec -i -t --namespace
alias klon = kubectl logs -f --namespace
alias kpfn = kubectl port-forward --namespace
alias kgn = kubectl get --namespace
alias kdn = kubectl describe --namespace
alias krmn = kubectl delete --namespace
alias kgpon = kubectl get pods --namespace
alias kdpon = kubectl describe pods --namespace
alias krmpon = kubectl delete pods --namespace
alias kgdepn = kubectl get deployment --namespace
alias kddepn = kubectl describe deployment --namespace
alias krmdepn = kubectl delete deployment --namespace
alias kgstsn = kubectl get statefulset --namespace
alias kdstsn = kubectl describe statefulset --namespace
alias krmstsn = kubectl delete statefulset --namespace
alias kgsvcn = kubectl get service --namespace
alias kdsvcn = kubectl describe service --namespace
alias krmsvcn = kubectl delete service --namespace
alias kgingn = kubectl get ingress --namespace
alias kdingn = kubectl describe ingress --namespace
alias krmingn = kubectl delete ingress --namespace
alias kgcmn = kubectl get configmap --namespace
alias kdcmn = kubectl describe configmap --namespace
alias krmcmn = kubectl delete configmap --namespace
alias kgsecn = kubectl get secret --namespace
alias kdsecn = kubectl describe secret --namespace
alias krmsecn = kubectl delete secret --namespace
alias kgoyamln = kubectl get -o=yaml --namespace
alias kgpooyamln = kubectl get pods -o=yaml --namespace
alias kgdepoyamln = kubectl get deployment -o=yaml --namespace
alias kgstsoyamln = kubectl get statefulset -o=yaml --namespace
alias kgsvcoyamln = kubectl get service -o=yaml --namespace
alias kgingoyamln = kubectl get ingress -o=yaml --namespace
alias kgcmoyamln = kubectl get configmap -o=yaml --namespace
alias kgsecoyamln = kubectl get secret -o=yaml --namespace
alias kgowiden = kubectl get -o=wide --namespace
alias kgpoowiden = kubectl get pods -o=wide --namespace
alias kgdepowiden = kubectl get deployment -o=wide --namespace
alias kgstsowiden = kubectl get statefulset -o=wide --namespace
alias kgsvcowiden = kubectl get service -o=wide --namespace
alias kgingowiden = kubectl get ingress -o=wide --namespace
alias kgcmowiden = kubectl get configmap -o=wide --namespace
alias kgsecowiden = kubectl get secret -o=wide --namespace
alias kgojsonn = kubectl get -o=json --namespace
alias kgpoojsonn = kubectl get pods -o=json --namespace
alias kgdepojsonn = kubectl get deployment -o=json --namespace
alias kgstsojsonn = kubectl get statefulset -o=json --namespace
alias kgsvcojsonn = kubectl get service -o=json --namespace
alias kgingojsonn = kubectl get ingress -o=json --namespace
alias kgcmojsonn = kubectl get configmap -o=json --namespace
alias kgsecojsonn = kubectl get secret -o=json --namespace
alias kgsln = kubectl get --show-labels --namespace
alias kgposln = kubectl get pods --show-labels --namespace
alias kgdepsln = kubectl get deployment --show-labels --namespace
alias kgstssln = kubectl get statefulset --show-labels --namespace
alias kgsvcsln = kubectl get service --show-labels --namespace
alias kgingsln = kubectl get ingress --show-labels --namespace
alias kgcmsln = kubectl get configmap --show-labels --namespace
alias kgsecsln = kubectl get secret --show-labels --namespace
alias kgwn = hwatch "kubectl get --namespace"
alias kgpown = hwatch "kubectl get pods --namespace"
alias kgdepwn = hwatch "kubectl get deployment --namespace"
alias kgstswn = hwatch "kubectl get statefulset --namespace"
alias kgsvcwn = hwatch "kubectl get service --namespace"
alias kgingwn = hwatch "kubectl get ingress --namespace"
alias kgcmwn = hwatch "kubectl get configmap --namespace"
alias kgsecwn = hwatch "kubectl get secret --namespace"
alias kgwoyamln = hwatch "kubectl get -o=yaml --namespace"
alias kgpowoyamln = hwatch "kubectl get pods -o=yaml --namespace"
alias kgdepwoyamln = hwatch "kubectl get deployment -o=yaml --namespace"
alias kgstswoyamln = hwatch "kubectl get statefulset -o=yaml --namespace"
alias kgsvcwoyamln = hwatch "kubectl get service -o=yaml --namespace"
alias kgingwoyamln = hwatch "kubectl get ingress -o=yaml --namespace"
alias kgcmwoyamln = hwatch "kubectl get configmap -o=yaml --namespace"
alias kgsecwoyamln = hwatch "kubectl get secret -o=yaml --namespace"
alias kgowidesln = kubectl get -o=wide --show-labels --namespace
alias kgpoowidesln = kubectl get pods -o=wide --show-labels --namespace
alias kgdepowidesln = kubectl get deployment -o=wide --show-labels --namespace
alias kgstsowidesln = kubectl get statefulset -o=wide --show-labels --namespace
alias kgsvcowidesln = kubectl get service -o=wide --show-labels --namespace
alias kgingowidesln = kubectl get ingress -o=wide --show-labels --namespace
alias kgcmowidesln = kubectl get configmap -o=wide --show-labels --namespace
alias kgsecowidesln = kubectl get secret -o=wide --show-labels --namespace
alias kgslowiden = kubectl get --show-labels -o=wide --namespace
alias kgposlowiden = kubectl get pods --show-labels -o=wide --namespace
alias kgdepslowiden = kubectl get deployment --show-labels -o=wide --namespace
alias kgstsslowiden = kubectl get statefulset --show-labels -o=wide --namespace
alias kgsvcslowiden = kubectl get service --show-labels -o=wide --namespace
alias kgingslowiden = kubectl get ingress --show-labels -o=wide --namespace
alias kgcmslowiden = kubectl get configmap --show-labels -o=wide --namespace
alias kgsecslowiden = kubectl get secret --show-labels -o=wide --namespace
alias kgwowiden = hwatch "kubectl get -o=wide --namespace"
alias kgpowowiden = hwatch "kubectl get pods -o=wide --namespace"
alias kgdepwowiden = hwatch "kubectl get deployment -o=wide --namespace"
alias kgstswowiden = hwatch "kubectl get statefulset -o=wide --namespace"
alias kgsvcwowiden = hwatch "kubectl get service -o=wide --namespace"
alias kgingwowiden = hwatch "kubectl get ingress -o=wide --namespace"
alias kgcmwowiden = hwatch "kubectl get configmap -o=wide --namespace"
alias kgsecwowiden = hwatch "kubectl get secret -o=wide --namespace"
alias kgwojsonn = hwatch "kubectl get -o=json --namespace"
alias kgpowojsonn = hwatch "kubectl get pods -o=json --namespace"
alias kgdepwojsonn = hwatch "kubectl get deployment -o=json --namespace"
alias kgstswojsonn = hwatch "kubectl get statefulset -o=json --namespace"
alias kgsvcwojsonn = hwatch "kubectl get service -o=json --namespace"
alias kgingwojsonn = hwatch "kubectl get ingress -o=json --namespace"
alias kgcmwojsonn = hwatch "kubectl get configmap -o=json --namespace"
alias kgsecwojsonn = hwatch "kubectl get secret -o=json --namespace"
alias kgslwn = hwatch "kubectl get --show-labels --namespace"
alias kgposlwn = hwatch "kubectl get pods --show-labels --namespace"
alias kgdepslwn = hwatch "kubectl get deployment --show-labels --namespace"
alias kgstsslwn = hwatch "kubectl get statefulset --show-labels --namespace"
alias kgsvcslwn = hwatch "kubectl get service --show-labels --namespace"
alias kgingslwn = hwatch "kubectl get ingress --show-labels --namespace"
alias kgcmslwn = hwatch "kubectl get configmap --show-labels --namespace"
alias kgsecslwn = hwatch "kubectl get secret --show-labels --namespace"
alias kgwsln = hwatch "kubectl get --show-labels --namespace"
alias kgpowsln = hwatch "kubectl get pods --show-labels --namespace"
alias kgdepwsln = hwatch "kubectl get deployment --show-labels --namespace"
alias kgstswsln = hwatch "kubectl get statefulset --show-labels --namespace"
alias kgsvcwsln = hwatch "kubectl get service --show-labels --namespace"
alias kgingwsln = hwatch "kubectl get ingress --show-labels --namespace"
alias kgcmwsln = hwatch "kubectl get configmap --show-labels --namespace"
alias kgsecwsln = hwatch "kubectl get secret --show-labels --namespace"
alias kgslwowiden = hwatch "kubectl get --show-labels -o=wide --namespace"
alias kgposlwowiden = hwatch "kubectl get pods --show-labels -o=wide --namespace"
alias kgdepslwowiden = hwatch "kubectl get deployment --show-labels -o=wide --namespace"
alias kgstsslwowiden = hwatch "kubectl get statefulset --show-labels -o=wide --namespace"
alias kgsvcslwowiden = hwatch "kubectl get service --show-labels -o=wide --namespace"
alias kgingslwowiden = hwatch "kubectl get ingress --show-labels -o=wide --namespace"
alias kgcmslwowiden = hwatch "kubectl get configmap --show-labels -o=wide --namespace"
alias kgsecslwowiden = hwatch "kubectl get secret --show-labels -o=wide --namespace"
alias kgwowidesln = hwatch "kubectl get -o=wide --show-labels --namespace"
alias kgpowowidesln = hwatch "kubectl get pods -o=wide --show-labels --namespace"
alias kgdepwowidesln = hwatch "kubectl get deployment -o=wide --show-labels --namespace"
alias kgstswowidesln = hwatch "kubectl get statefulset -o=wide --show-labels --namespace"
alias kgsvcwowidesln = hwatch "kubectl get service -o=wide --show-labels --namespace"
alias kgingwowidesln = hwatch "kubectl get ingress -o=wide --show-labels --namespace"
alias kgcmwowidesln = hwatch "kubectl get configmap -o=wide --show-labels --namespace"
alias kgsecwowidesln = hwatch "kubectl get secret -o=wide --show-labels --namespace"
alias kgwslowiden = hwatch "kubectl get --show-labels -o=wide --namespace"
alias kgpowslowiden = hwatch "kubectl get pods --show-labels -o=wide --namespace"
alias kgdepwslowiden = hwatch "kubectl get deployment --show-labels -o=wide --namespace"
alias kgstswslowiden = hwatch "kubectl get statefulset --show-labels -o=wide --namespace"
alias kgsvcwslowiden = hwatch "kubectl get service --show-labels -o=wide --namespace"
alias kgingwslowiden = hwatch "kubectl get ingress --show-labels -o=wide --namespace"
alias kgcmwslowiden = hwatch "kubectl get configmap --show-labels -o=wide --namespace"
alias kgsecwslowiden = hwatch "kubectl get secret --show-labels -o=wide --namespace"
alias krrdep = kubectl rollout restart deployment
alias krrdepn = kubectl rollout restart deployment --namespace
alias krrds = kubectl rollout restart daemonset
alias krrdsn = kubectl rollout restart daemonset --namespace
alias krrsts = kubectl rollout restart statefulset
alias krrstsn = kubectl rollout restart statefulset --namespace
