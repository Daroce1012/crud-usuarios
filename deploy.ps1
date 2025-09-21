# Script de despliegue CRUD - Aplicación Distribuida
# Frontend: Apache + Proxy en servidor con IP flotante  
# Backend: Flask API en servidor interno

param(
    [string]$Action = "deploy"
)

Write-Host "=== DESPLIEGUE CRUD DISTRIBUIDO ===" -ForegroundColor Green

$FRONTEND_IP = "156.35.98.122"
$BACKEND_IP = "192.168.118.220"
$KEY_FILE = "id_rsa"

if ($Action -eq "deploy") {
    Write-Host "Desplegando aplicacion CRUD..." -ForegroundColor Yellow
    Write-Host "Frontend: $FRONTEND_IP (Apache + Proxy)"
    Write-Host "Backend: $BACKEND_IP (Flask API)"
    Write-Host ""
    
    # Desplegar backend
    Write-Host "1. Desplegando Backend..." -ForegroundColor Blue
    scp -i $KEY_FILE -r backend ubuntu@$FRONTEND_IP:/tmp/
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'scp -r /tmp/backend ubuntu@192.168.118.220:/tmp/'
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'ssh ubuntu@192.168.118.220 "cd /tmp/backend && pip3 install flask flask-cors --break-system-packages --quiet"'
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'ssh ubuntu@192.168.118.220 "pkill -f python3.*app.py; cd /tmp/backend && nohup python3 app.py > flask.log 2>&1 &"'
    
    # Desplegar frontend
    Write-Host "2. Desplegando Frontend..." -ForegroundColor Blue
    scp -i $KEY_FILE frontend/* ubuntu@$FRONTEND_IP:/tmp/
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'sudo cp /tmp/*.html /tmp/*.js /tmp/*.css /var/www/html/ && sudo systemctl reload apache2'
    
    Write-Host "`n=== APLICACION DESPLEGADA EXITOSAMENTE ===" -ForegroundColor Green
    Write-Host "Aplicacion Web: http://$FRONTEND_IP" -ForegroundColor Cyan
    Write-Host "API Backend: http://$BACKEND_IP`:5000/usuarios" -ForegroundColor Yellow
}
elseif ($Action -eq "test") {
    Write-Host "Verificando aplicacion..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Frontend: http://$FRONTEND_IP" -ForegroundColor Green
    Write-Host "API: http://$BACKEND_IP`:5000/usuarios" -ForegroundColor Green
    Write-Host ""
    Write-Host "Probando conectividad:" -ForegroundColor Blue
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'curl -s http://localhost/ | grep -q DOCTYPE && echo "Frontend OK" || echo "Frontend Error"'
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP "ssh ubuntu@$BACKEND_IP 'curl -s http://localhost:5000/usuarios >/dev/null && echo \"Backend OK\" || echo \"Backend Error\"'"
}
elseif ($Action -eq "status") {
    Write-Host "Estado de la aplicacion:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Frontend (Apache):" -ForegroundColor Blue
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP 'sudo systemctl is-active apache2'
    Write-Host "Backend (Flask):" -ForegroundColor Blue
    ssh -i $KEY_FILE ubuntu@$FRONTEND_IP "ssh ubuntu@$BACKEND_IP 'pgrep -f python3.*app.py >/dev/null && echo active || echo inactive'"
}
else {
    Write-Host "Uso: .\deploy_simple.ps1 -Action [deploy|test|status]" -ForegroundColor Red
    Write-Host ""
    Write-Host "Acciones disponibles:" -ForegroundColor Yellow
    Write-Host "  deploy - Despliega la aplicacion completa"
    Write-Host "  test   - Verifica conectividad"  
    Write-Host "  status - Muestra estado de servicios"
}