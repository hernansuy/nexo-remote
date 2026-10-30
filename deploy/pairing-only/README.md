# Nexo Pair — señalización sin retransmisión

Diseño solicitado por el propietario: el homelab ayuda a encontrar a los equipos y a negociar la conexión. Los datos de la sesión viajan entre los equipos.

## Qué se ejecuta

Solo `hbbs`, versión OSS 1.1.16 fijada por SHA-256 del archivo publicado oficialmente. `hbbr` no se extrae, instala ni arranca. No se usa la imagen `server-s6`, que iniciaría ambos componentes. Se mantienen las claves del servidor en un directorio privado del usuario de servicio.

El homelab recibe datos de control: identificadores, direcciones IP, presencia y mensajes para negociar la sesión. No es un servicio de tráfico cero. No se instala un proceso que retransmita pantalla, teclado, audio o archivos.

## Conectividad

- TCP 21115: prueba de NAT.
- TCP y UDP 21116: registro, señalización y negociación.
- TCP 21117 y 21119: sin servicio de retransmisión.
- `hbbs` también puede escuchar WebSocket 21118 dentro del contenedor; no publicar ese puerto para este cliente Windows nativo.

Los clientes pueden intentar el puerto de relay derivado de la dirección del servidor, pero no encontrarán `hbbr`. Una sesión que necesite retransmisión fallará. No prometer funcionamiento universal con CG-NAT simétrico o redes restrictivas. No se cambia el router ni se abre WAN desde este instalador.

## Despliegue preparado

Ejecutar `install.sh` con `nexo-pairing.service` al lado, como root exclusivamente dentro de un nuevo contenedor Debian cuyo hostname sea `nexo-pair`. El instalador rechaza otros hosts y una unidad ya existente. Necesita salida HTTPS para paquetes y el archivo oficial. No ejecutar sobre el host Proxmox ni sobre el bastión de administración.

Estado inicial: preparado, no desplegado. La creación/arranque del contenedor y cualquier publicación exterior están sujetos a las autorizaciones operativas del homelab.

## Aceptación

1. Unidad activa con usuario sin login y directorio privado; clave pública presente sin mostrar la privada.
2. Ningún proceso `hbbr`; no hay listeners de relay en 21117/21119.
3. Dos clientes Nexo con la misma dirección del servidor y su clave pública obtienen identificación.
4. Una sesión real entre dos redes muestra conexión directa; una transferencia grande no provoca un flujo equivalente de datos en el homelab.
5. Al bloquear la conexión directa entre los clientes, la sesión falla y no se retransmite mediante el homelab.

Retirada reversible: detener y deshabilitar solo `nexo-pairing.service`; conservar el directorio de claves y la base de datos. No eliminar el contenedor ni sus datos como rollback automático.
