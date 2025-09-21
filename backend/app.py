from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
from database import obtener_conexion, crear_tabla

app = Flask(__name__)
CORS(app)  # Permitir peticiones desde el frontend

# Crear la tabla al iniciar
crear_tabla()

# Ruta para obtener todos los usuarios
@app.route('/usuarios', methods=['GET'])
def obtener_usuarios():
    conn = obtener_conexion()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM usuarios')
    usuarios = cursor.fetchall()
    conn.close()
    
    # Convertir a lista de diccionarios
    resultado = []
    for usuario in usuarios:
        resultado.append({
            'id': usuario[0],
            'nombre': usuario[1],
            'email': usuario[2],
            'edad': usuario[3]
        })
    
    return jsonify(resultado)

# Ruta para obtener un usuario por ID
@app.route('/usuarios/<int:id>', methods=['GET'])
def obtener_usuario(id):
    conn = obtener_conexion()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM usuarios WHERE id = ?', (id,))
    usuario = cursor.fetchone()
    conn.close()
    
    if usuario:
        return jsonify({
            'id': usuario[0],
            'nombre': usuario[1],
            'email': usuario[2],
            'edad': usuario[3]
        })
    else:
        return jsonify({'error': 'Usuario no encontrado'}), 404

# Ruta para crear un nuevo usuario
@app.route('/usuarios', methods=['POST'])
def crear_usuario():
    datos = request.get_json()
    nombre = datos.get('nombre')
    email = datos.get('email')
    edad = datos.get('edad')
    
    if not nombre or not email:
        return jsonify({'error': 'Nombre y email son obligatorios'}), 400
    
    conn = obtener_conexion()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            'INSERT INTO usuarios (nombre, email, edad) VALUES (?, ?, ?)',
            (nombre, email, edad)
        )
        conn.commit()
        usuario_id = cursor.lastrowid
        conn.close()
        
        return jsonify({
            'id': usuario_id,
            'nombre': nombre,
            'email': email,
            'edad': edad
        }), 201
    except sqlite3.IntegrityError:
        conn.close()
        return jsonify({'error': 'El email ya existe'}), 400

# Ruta para actualizar un usuario
@app.route('/usuarios/<int:id>', methods=['PUT'])
def actualizar_usuario(id):
    datos = request.get_json()
    nombre = datos.get('nombre')
    email = datos.get('email')
    edad = datos.get('edad')
    
    conn = obtener_conexion()
    cursor = conn.cursor()
    
    cursor.execute(
        'UPDATE usuarios SET nombre = ?, email = ?, edad = ? WHERE id = ?',
        (nombre, email, edad, id)
    )
    
    if cursor.rowcount == 0:
        conn.close()
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    conn.commit()
    conn.close()
    
    return jsonify({
        'id': id,
        'nombre': nombre,
        'email': email,
        'edad': edad
    })

# Ruta para eliminar un usuario
@app.route('/usuarios/<int:id>', methods=['DELETE'])
def eliminar_usuario(id):
    conn = obtener_conexion()
    cursor = conn.cursor()
    
    cursor.execute('DELETE FROM usuarios WHERE id = ?', (id,))
    
    if cursor.rowcount == 0:
        conn.close()
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    conn.commit()
    conn.close()
    
    return jsonify({'mensaje': 'Usuario eliminado correctamente'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)