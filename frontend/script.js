const API_URL = '/api/usuarios';

// Elementos del DOM
const usuarioForm = document.getElementById('usuario-form');
const formTitle = document.getElementById('form-title');
const submitBtn = document.getElementById('submit-btn');
const cancelBtn = document.getElementById('cancel-btn');
const usuariosBody = document.getElementById('usuarios-body');
const usuarioId = document.getElementById('usuario-id');
const nombreInput = document.getElementById('nombre');
const emailInput = document.getElementById('email');
const edadInput = document.getElementById('edad');

// Cargar usuarios al iniciar
document.addEventListener('DOMContentLoaded', cargarUsuarios);

// Evento para enviar el formulario
usuarioForm.addEventListener('submit', manejarEnvioFormulario);

// Evento para cancelar edición
cancelBtn.addEventListener('click', resetearFormulario);

// Función para cargar usuarios
async function cargarUsuarios() {
    try {
        const respuesta = await fetch(API_URL);
        const usuarios = await respuesta.json();
        
        usuariosBody.innerHTML = '';
        
        usuarios.forEach(usuario => {
            const fila = document.createElement('tr');
            
            fila.innerHTML = `
                <td>${usuario.id}</td>
                <td>${usuario.nombre}</td>
                <td>${usuario.email}</td>
                <td>${usuario.edad || ''}</td>
                <td>
                    <button class="edit" onclick="editarUsuario(${usuario.id})">Editar</button>
                    <button class="delete" onclick="eliminarUsuario(${usuario.id})">Eliminar</button>
                </td>
            `;
            
            usuariosBody.appendChild(fila);
        });
    } catch (error) {
        console.error('Error al cargar usuarios:', error);
    }
}

// Función para manejar el envío del formulario
async function manejarEnvioFormulario(e) {
    e.preventDefault();
    
    const usuario = {
        nombre: nombreInput.value,
        email: emailInput.value,
        edad: edadInput.value ? parseInt(edadInput.value) : null
    };
    
    try {
        if (usuarioId.value) {
            // Actualizar usuario existente
            await fetch(`${API_URL}/${usuarioId.value}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(usuario)
            });
        } else {
            // Crear nuevo usuario
            await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(usuario)
            });
        }
        
        resetearFormulario();
        cargarUsuarios();
    } catch (error) {
        console.error('Error al guardar usuario:', error);
    }
}

// Función para editar usuario
async function editarUsuario(id) {
    try {
        const respuesta = await fetch(`${API_URL}/${id}`);
        const usuario = await respuesta.json();
        
        usuarioId.value = usuario.id;
        nombreInput.value = usuario.nombre;
        emailInput.value = usuario.email;
        edadInput.value = usuario.edad || '';
        
        formTitle.textContent = 'Editar Usuario';
        submitBtn.textContent = 'Actualizar';
        cancelBtn.style.display = 'inline-block';
    } catch (error) {
        console.error('Error al cargar usuario para editar:', error);
    }
}

// Función para eliminar usuario
async function eliminarUsuario(id) {
    if (confirm('¿Estás seguro de que quieres eliminar este usuario?')) {
        try {
            await fetch(`${API_URL}/${id}`, {
                method: 'DELETE'
            });
            
            cargarUsuarios();
        } catch (error) {
            console.error('Error al eliminar usuario:', error);
        }
    }
}

// Función para resetear el formulario
function resetearFormulario() {
    usuarioId.value = '';
    usuarioForm.reset();
    formTitle.textContent = 'Agregar Usuario';
    submitBtn.textContent = 'Guardar';
    cancelBtn.style.display = 'none';
}