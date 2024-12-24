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

alias k='kubectl'
alias ka='kubectl apply --recursive -f'
alias kk='kubectl kustomize'
alias kex='kubectl exec -i -t'
alias klo='kubectl logs -f'
alias kp='kubectl proxy'
alias kpf='kubectl port-forward'
alias kg='kubectl get'
alias kgw='kubectl get -o wide'
alias kd='kubectl describe'
alias krm='kubectl delete'
alias krun='kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t'
alias kdpo='kubectl describe pods'
alias kgpo='kubectl get pods'
alias kgpow='kubectl get pods -o wide'
alias krmpo='kubectl delete pods'
alias kddep='kubectl describe deployment'
alias kgdep='kubectl get deployment'
alias kgdepw='kubectl get deployment -o wide'
alias krmdep='kubectl delete deployment'
alias kdsts='kubectl describe statefulset'
alias kgsts='kubectl get statefulset'
alias kgstsw='kubectl get statefulset -o wide'
alias krmsts='kubectl delete statefulset'
alias kdsvc='kubectl describe service'
alias kgsvc='kubectl get service'
alias kgsvcw='kubectl get service -o wide'
alias krmsvc='kubectl delete service'
alias kging='kubectl get ingress'
alias kding='kubectl describe ingress'
alias kgingw='kubectl get ingress -o wide'
alias krming='kubectl delete ingress'
alias kdcm='kubectl describe configmap'
alias kgcm='kubectl get configmap'
alias kgcmw='kubectl get configmap -o wide'
alias krmcm='kubectl delete configmap'
alias kgsecw='kubectl get secret -o wide'
alias kgsec='kubectl get secret'
alias kdsec='kubectl describe secret'
alias krmsec='kubectl delete secret'
alias kdno='kubectl describe nodes'
alias kgno='kubectl get nodes'
alias kgnow='kubectl get nodes -o wide'
alias kgns='kubectl get namespaces'
alias kdns='kubectl describe namespaces'
alias krmns='kubectl delete namespaces'
alias kconf='kubectl config'
