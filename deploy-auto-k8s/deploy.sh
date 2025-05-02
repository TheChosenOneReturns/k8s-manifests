#!/usr/bin/env bash


set -euo pipefail

# ───── CONFIGURACIÓN ─────
REPO_WEB="https://github.com/TheChosenOneReturns/web-content.git"
REPO_K8S="https://github.com/TheChosenOneReturns/k8s-manifests.git"

USER_HOME="$(eval echo ~)"
PROYECTO_DIR="$USER_HOME/Desktop/proyecto-kubernetes"
WEB_DIR="$PROYECTO_DIR/web-content"
K8S_DIR="$PROYECTO_DIR/k8s-manifests"

MOUNT_PATH="$(realpath "$WEB_DIR")"
MINIKUBE_DRIVER="docker"

# ───── FUNCIONES ─────

log() {
  echo -e "\n $1\n"
}

check_dependency() {
  if ! command -v "$1" &>/dev/null; then
    echo " Error: '$1' no está instalado."
    exit 1
  fi
}

clone_if_needed() {
  local url="$1"
  local dest="$2"
  if [ ! -d "$dest" ]; then
    log "Clonando $url en $dest..."
    git clone "$url" "$dest"
  else
    log " $dest ya existe. Omitiendo clonación."
  fi
}

destroy_resources() {
  log " Eliminando recursos de Kubernetes..."

  kubectl delete -f "$K8S_DIR/services/web-service.yaml" --ignore-not-found
  kubectl delete -f "$K8S_DIR/deployments/web-deployment.yaml" --ignore-not-found
  kubectl delete -f "$K8S_DIR/persistent-volumes/pvc.yaml" --ignore-not-found
  kubectl delete -f "$K8S_DIR/persistent-volumes/pv.yaml" --ignore-not-found

  log " ¿Querés eliminar la carpeta $PROYECTO_DIR también? [s/N]"
  read -r respuesta
  if [[ "$respuesta" =~ ^[sS]$ ]]; then
    rm -rf "$PROYECTO_DIR"
    log " Carpeta eliminada."
  else
    log " Carpetas conservadas."
  fi

  exit 0
}

# ───── VALIDACIONES ─────

log " Verificando dependencias..."
for cmd in docker minikube kubectl git; do
  check_dependency "$cmd"
done

# ───── OPCIÓN DE DESTRUCCIÓN ─────
if [[ "${1:-}" == "--destroy" ]]; then
  destroy_resources
fi

# ───── CREACIÓN DE ESTRUCTURA ─────

log " Creando estructura de proyecto en $PROYECTO_DIR..."
mkdir -p "$PROYECTO_DIR"
clone_if_needed "$REPO_WEB" "$WEB_DIR"
clone_if_needed "$REPO_K8S" "$K8S_DIR"

# ───── INICIAR MINIKUBE CON MONTAJE ─────

log " Iniciando Minikube y montando $MOUNT_PATH..."
minikube start --driver="$MINIKUBE_DRIVER" --mount --mount-string="${MOUNT_PATH}:/mnt/web"

# ───── APLICAR MANIFIESTOS DE K8S ─────

log " Aplicando manifiestos de Kubernetes..."

kubectl apply -f "$K8S_DIR/persistent-volumes/pv.yaml"
kubectl apply -f "$K8S_DIR/persistent-volumes/pvc.yaml"
kubectl apply -f "$K8S_DIR/deployments/web-deployment.yaml"
kubectl apply -f "$K8S_DIR/services/web-service.yaml"

# ───── MOSTRAR SITIO ─────

log " Abriendo el sitio web..."
minikube service web-service

log " ¡Despliegue exitoso! Tu sitio está online "
