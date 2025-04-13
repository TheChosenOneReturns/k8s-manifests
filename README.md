# 🌐 Despliegue Web Estático con Kubernetes + Minikube (Windows)

Este repositorio contiene los manifiestos necesarios para desplegar una página web estática usando Kubernetes sobre Minikube, montando los archivos locales de tu sitio directamente desde Windows.

---

## 📁 Estructura del proyecto

```plaintext
proyecto-kubernetes/
├── k8s-manifests/
│   ├── deployments/
│   │   └── web-deployment.yaml
│   ├── services/
│   │   └── web-service.yaml
│   ├── persistent-volumes/
│   │   ├── pv.yaml
│   │   └── pvc.yaml
│   └── ingress/
│
├── web-content/
│   ├── index.html
│   ├── style.css
│   └── assets/
```

---

## 🧩 Requisitos

- 🐳 Docker
- 🌱 Minikube
- 💻 Windows 10/11 con GitBash (RECOMENDADO), POWERSHELL, o utilizando incluso cmd (no recomendado) será suficiente.
- 📁 Carpeta `web-content/` con tu sitio estático

---

## 🚀 Pasos para desplegar

### 1️⃣ Iniciar Minikube con montaje

```bash
minikube start --driver=docker --mount --mount-string="C:\Users\arieb\proyecto-kubernetes\web-content:/mnt/web"
```

---

### 2️⃣ Aplicar manifiestos de Kubernetes

```bash
kubectl apply -f k8s-manifests/persistent-volumes/pv.yaml
kubectl apply -f k8s-manifests/persistent-volumes/pvc.yaml
kubectl apply -f k8s-manifests/deployments/web-deployment.yaml
kubectl apply -f k8s-manifests/services/web-service.yaml
```

---

### 3️⃣ Abrir la app en el navegador

```bash
minikube service web-service
```

---

## 🛠 Troubleshooting

| Problema | Solución |
|---------|----------|
| ❌ No se ve el sitio | Verifica que `index.html` está en `web-content/` y que `/mnt/web` se montó correctamente |
| ❌ Error de imagen | Ejecuta `docker pull nginx:alpine` y `minikube image load nginx:alpine` |

---

## 📸 Resultado Esperado

El contenido de `web-content/` (incluyendo `index.html`, `style.css`, y `/assets`) se sirve automáticamente por NGINX.

