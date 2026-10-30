# Nexo Remote · Windows

Versión personal de Hernan basada en RustDesk. Primera personalización: 30 de octubre de 2026.

## Estado real

- Nombre visible: Nexo Remote. Identificador interno: NexoRemote (sin espacios, para servicios y rutas de Windows).
- Diseño claro: azul, blanco y tarjetas con bordes suaves; icono propio.
- La compilación de Windows utiliza por defecto `127.0.0.1` como servidor de identificación: solo sirve como preparación local. NO es una dirección válida para los equipos de clientes externos.
- Dirección y clave PÚBLICA del servidor configurables al compilar mediante `NEXO_SERVER` y `NEXO_KEY`. El usuario también puede configurar un servidor propio en los ajustes de red.
- El mecanismo existente del proyecto desactiva la búsqueda automática de actualizaciones oficiales para clientes con nombre personalizado. Las actualizaciones de Nexo deben compilarse y distribuirse por separado.
- La independencia de todos los servicios externos no está certificada: falta comprobar el tráfico real, las conexiones directas y la retransmisión en dos redes distintas.
- No se han abierto puertos, instalado servicios ni desplegado un servidor en el PC.

## Compilación

El flujo manual `.github/workflows/nexo-windows.yml` prepara Windows x64 siguiendo los pasos y versiones del flujo original. Genera un ZIP con `NexoRemote.exe` y sus bibliotecas; el ejecutable no funciona por separado. No publica una release ni llama a un servicio de firma. La primera compilación todavía debe ejecutarse y superar sus pruebas.

El flujo reutiliza la generación de enlaces Rust/Flutter del proyecto. Para construir sin GitHub hay que disponer de esos enlaces generados, Rust, Flutter, MSVC, LLVM y vcpkg con las versiones del flujo; no basta con `flutter build windows`. No se han instalado esas dependencias en este PC.

Los binarios de prueba no tienen una firma de editor propia. El instalador y el ciclo de actualización requieren validación posterior con el nombre nuevo.

## Servidor propio

El diseño vigente utiliza exclusivamente `hbbs` (identificación y negociación) en un servicio aislado del homelab. No se instalará `hbbr` (retransmisión). Los archivos de instalación están en `deploy/pairing-only/`; el despliegue y la publicación aún no se han ejecutado.

El emparejador debe ser accesible desde ambos equipos. Ayuda a negociar la conexión directa, pero algunas combinaciones de CG-NAT o redes restrictivas impiden el P2P. En ese caso la sesión fallará sin retransmisión. El homelab recibe identificadores, direcciones y mensajes de control; no se pretende ocultar esos metadatos ni prometer tráfico cero.

Para clientes Windows nativos, planificar únicamente TCP 21115, TCP 21116 y UDP 21116. No publicar 21117, 21118 ni 21119. Guardar la clave privada fuera del repositorio; solo la pública se incluye en el cliente. Realizar la prueba final desde dos conexiones a Internet distintas y verificar un caso negativo sin P2P.

## Cambios y superficie de regresión

- `src/common.rs`: identidad y directorios de configuración del cliente Windows; servidor por defecto y tema inicial. Es necesario para separar Nexo de una instalación de RustDesk. Submódulos y protocolos permanecen en la revisión original.
- `flutter/lib/main.dart`: tema de las ventanas Windows.
- `flutter/lib/desktop/pages/desktop_home_page.dart`: identidad, anchura del panel y contenedor de conexión.
- `flutter/lib/desktop/pages/connection_page.dart`: aspecto y espaciado de la tarjeta existente; conserva los controladores y las acciones originales.
- `flutter/windows/runner/Runner.rc` e iconos: metadatos y recursos de Windows.
- Nuevo flujo manual de compilación: paquete Windows x64 con nombre propio.

La compilación nativa, la instalación como servicio, el acceso remoto real y el tráfico de red aún no están verificados. No se presenta esta primera edición como producto terminado.

## Licencia y atribución

Derivado de https://github.com/rustdesk/rustdesk. Se conserva `LICENCE` (GNU AGPL v3), los avisos originales y la atribución a los autores. Las modificaciones se distribuyen bajo la misma licencia. El nombre y los recursos de Nexo Remote identifican esta edición; no representan una versión oficial de RustDesk.
