# CRUD Usuarios - Despliegue Distribuido

Aplicación CRUD de usuarios con arquitectura distribuida en servidores separados usando OpenStack.

## 🏗️ Arquitectura

```
Internet
    ↓
Frontend Server (156.35.98.122:80) ← IP Flotante + Nginx
    ↓ (API calls HTTP)
Backend Server (192.168.118.220:5000) ← Red interna + Flask API
```

## 📁 Estructura del Proyecto

```
crud-usuarios/
├── backend/                    # Aplicación Flask (servidor backend)
│   ├── app.py                 # API REST principal
│   ├── database.py            # Configuración de base de datos
│   ├── requirements.txt       # Dependencias Python
│   └── usuarios.db            # Base de datos SQLite
├── frontend/                  # Aplicación web (servidor frontend)
│   ├── index.html            # Interfaz principal
│   ├── script.js             # Lógica del frontend (apunta a backend)
│   └── style.css             # Estilos CSS
├── terraform/                # Infraestructura como código
│   ├── floating_ip.tf        # Configuración IP flotante
│   ├── instances.tf          # Definición de instancias separadas
│   ├── keypair.tf            # Claves SSH
│   ├── main.tf              # Configuración principal
│   ├── outputs.tf           # Outputs con IPs de servidores
│   ├── security.tf          # Security groups (HTTP + API)
│   ├── terraform.tfvars     # Variables de configuración
│   └── variables.tf         # Definición de variables
├── deploy.ps1               # 🚀 Script de despliegue
├── id_rsa.pub              # Clave pública SSH
└── README.md               # Este archivo
```

## 🚀 Despliegue Automatizado

### ⚡ Despliegue Completo
```powershell
# Desplegar aplicación completa en arquitectura distribuida
.\deploy.ps1 -Action deploy
```

### 📋 Otras Opciones
```powershell
# Verificar estado
.\deploy.ps1 -Action status

# Probar conectividad
.\deploy.ps1 -Action test
```

## 🌐 Acceso a la Aplicación

Una vez desplegada:

- **🌐 Aplicación Web**: http://156.35.98.122
- **🔧 API Backend**: http://192.168.118.220:5000/usuarios
- **📊 Gestión CRUD**: Interfaz web completa para crear, leer, actualizar y eliminar usuarios

## 📋 Funcionalidades CRUD

- ✅ **Crear** usuarios (nombre, email, edad)
- 📖 **Leer** lista completa de usuarios
- ✏️ **Actualizar** información de usuarios existentes
- 🗑️ **Eliminar** usuarios
- 🔄 **Actualización en tiempo real** de la interfaz

## ⚙️ Tecnologías

### Backend (Servidor 192.168.118.220)
- **Framework**: Python Flask
- **Base de datos**: SQLite
- **CORS**: Habilitado para comunicación con frontend
- **Servicio**: systemd (crud-backend)

### Frontend (Servidor 156.35.98.122)
- **Archivos**: HTML + JavaScript + CSS
- **Servidor web**: Nginx
- **API calls**: Configuradas para backend interno
- **Acceso**: IP flotante pública

### Infraestructura
- **Cloud**: OpenStack
- **IaC**: Terraform
- **Networking**: Red interna + IP flotante
- **Seguridad**: Security groups configurados

## 🔒 Configuración de Seguridad

- **Backend**: Accesible solo desde red interna
- **Frontend**: Acceso público controlado via IP flotante
- **SSH**: Habilitado en ambos servidores
- **Puertos**: 
  - Frontend: 80 (HTTP), 22 (SSH)
  - Backend: 5000 (API), 22 (SSH)

## 🔧 Despliegue Manual de Infraestructura

Si necesitas recrear la infraestructura:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## 📞 Soporte y Troubleshooting

### Verificar Estado Completo
```powershell
.\deploy_app.ps1 -Action status
```

### Conectarse a los Servidores
```bash
# Frontend (desde internet)
ssh -i id_rsa ubuntu@156.35.98.122

# Backend (desde frontend)
ssh -i id_rsa ubuntu@192.168.118.220
```

### Ver Logs Detallados
```powershell
# Logs del backend
.\deploy_app.ps1 -Action logs -Backend

# Logs del frontend
.\deploy_app.ps1 -Action logs -Frontend
```

**¡Tu aplicación CRUD está lista para ser desplegada en arquitectura distribuida!** 🚀