# 🌐 Despliegue Web Estático con Kubernetes + Minikube (Windows)

Este repositorio contiene todo lo necesario para desplegar una **página web estática** usando **Kubernetes sobre Minikube** en **Windows**, montando los archivos locales de tu sitio directamente en un contenedor NGINX.

---

## 📁 Estructura del Proyecto

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
│
├── web-content/
│   ├── index.html
│   ├── style.css
│   └── assets/
```

---

## 🧩 Requisitos Previos

- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y funcionando
- ✅ [Minikube](https://minikube.sigs.k8s.io/docs/start/) instalado
- ✅ [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado
- ✅ Tener habilitado **WSL 2**
- ✅ Git Bash o PowerShell en Windows
- ✅ Carpeta `web-content/` con tu sitio web estático

---

## ⚙️ Instalación Rápida (Docker, WSL2, Minikube, kubectl)

### 1️⃣ Habilitar WSL 2

Abrí **PowerShell como administrador** y ejecutá:

```powershell
wsl --install
```

Reiniciá tu PC si es necesario. Luego forzá WSL 2 por defecto:

```powershell
wsl --set-default-version 2
```

---

### 2️⃣ Instalar Docker Desktop

1. Descargalo desde: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Durante la instalación:
   - ✅ Activá `Use WSL 2 instead of Hyper-V`
   - ✅ Activá "Integrate with WSL 2"
3. Una vez instalado, asegurate de que Docker esté corriendo (ballenita verde en la barra)

---

### 3️⃣ Instalar Minikube y kubectl con Chocolatey

Abrí Git Bash o PowerShell:

```bash
choco install minikube kubernetes-cli -y
```

> Si no tenés Chocolatey, instalalo desde: [https://chocolatey.org/install](https://chocolatey.org/install)

---

### 4️⃣ Verificar instalación

```bash
docker --version
minikube version
kubectl version --client
```

---

## 📝 Clonar este Repositorio donde contengas tu página web estatica, utilizaremos esta de aquí para el ejemplo: https://github.com/TheChosenOneReturns/web-content/tree/main

Desde Git Bash o PowerShell clona este repostiorio en donde tengas tu repositorio web:

```bash
git clone https://github.com/TheChosenOneReturns/k8s-manifests.git
cd proyecto-kubernetes
```
Recuerda que tienes arriba la estructura de como debería de verse tu repositorio
---


## 🚀 Despliegue Paso a Paso

### 1️⃣ Iniciar Minikube montando la carpeta del sitio

Reemplazá la ruta por la de tu PC:

```bash
minikube start --driver=docker --mount --mount-string="C:\ruta\real\a\proyecto-kubernetes\web-content:/mnt/web"
```
NOTA: Reemplazar la ruta "C:\ruta\real\a\proyecto-kubernetes\web-content" oor la ruta en donde clonaste el repositorio web.
      Es importante tener en cuenta que al final de tu ruta, debe de permanecer ":/mnt/web" para indicar correctamente el mapeo en el deploy.
---

### 2️⃣ Aplicar los manifiestos de Kubernetes

```bash
kubectl apply -f k8s-manifests/persistent-volumes/pv.yaml
kubectl apply -f k8s-manifests/persistent-volumes/pvc.yaml
kubectl apply -f k8s-manifests/deployments/web-deployment.yaml
kubectl apply -f k8s-manifests/services/web-service.yaml
```

---

### 3️⃣ Acceder al sitio desde el navegador

```bash
minikube service web-service
```

Esto abrirá tu navegador con la URL del servicio. Si no lo hace, te la mostrará por consola.

---

## 🛠 Solución de Problemas

| ❌ Problema                      | ✅ Solución                                                                 |
|-------------------------------|----------------------------------------------------------------------------|
| El sitio no se carga           | Verificá que `index.html` esté en `web-content/` y que el montaje sea correcto |
| Falla con la imagen de NGINX   | Ejecutá `docker pull nginx:alpine` y luego `minikube image load nginx:alpine` |
| El pod no arranca              | Revisá con `kubectl get pods` y hacé `kubectl describe pod <nombre>` para ver el error |

---

## 📸 Resultado Esperado

Una vez desplegado, NGINX sirve automáticamente el contenido de tu carpeta `web-content/`, incluyendo:

- `index.html`
- `style.css`
- Cualquier archivo en `/assets/`

---

¡Todo listo! Si seguiste los pasos, ya tenés un entorno Kubernetes funcionando con tu sitio web estático desplegado 💻🚀
