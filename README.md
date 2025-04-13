# k8s-manifests
📄 README - Despliegue Web Estático con Minikube y Kubernetes
Este proyecto permite desplegar una web estática usando Minikube y Kubernetes. El sitio está almacenado localmente y se monta en el contenedor NGINX mediante un volumen persistente.

🗂 Estructura del proyecto
Directorio base: C:\Users\*TU USUARIO*\proyecto-kubernetes

proyecto-kubernetes/
├── k8s-manifests/
│   ├── deployments/
│   ├── services/
│   ├── persistent-volumes/
│   └── ingress/
│
├── web-content/
│   ├── index.html
│   ├── style.css
│   └── assets/

✅ Requisitos
- Docker
- Minikube
- GitBash(RECOMENDABLE), WindowsPowerShell, o la misma terminal de Windows (No lo recomiendo, tiene sus limitaciones)
- Carpeta con tu sitio estático (web-content) correctamente estructurada

🚀 Instrucciones
1. Iniciar Minikube con tu sitio montado
Utilizando BASH:

minikube start --driver=docker --mount --mount-string="C:\Users\*TU USUARIO*\proyecto-kubernetes\web-content:/mnt/web"

2. Aplicar los manifiestos
Desde la raíz del proyecto:

Utilizando BASH y siguiendo ESE ORDEN:
kubectl apply -f k8s-manifests/persistent-volumes/pv.yaml
kubectl apply -f k8s-manifests/persistent-volumes/pvc.yaml
kubectl apply -f k8s-manifests/deployments/web-deployment.yaml
kubectl apply -f k8s-manifests/services/web-service.yaml

3. Ver tu sitio en el navegador

minikube service web-service

📦 Detalles importantes
El contenedor nginx servirá automáticamente index.html desde /usr/share/nginx/html, gracias al volumen montado desde tu carpeta local.

El CSS y archivos en assets/ también estarán disponibles.

🧯 Problemas comunes
❌ No carga la página
➡️ Asegúrate de que el index.html está en web-content/ y que Minikube lo montó correctamente.

❌ Imagen no se descarga (nginx)
➡️ Ejecutá en BASH:
docker pull nginx:alpine
minikube image load nginx:alpine
