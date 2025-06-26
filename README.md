# ⚙️ dev-setup-Archlinux-es

Instaladores automatizados para configurar un entorno completo de desarrollo en Archlinux, usando herramientas modernas y gestionadas por versión: `zsh`, `git`, `ssh`, `ruby`, `node`, `python`, `java`, `postgresql`, `docker`.

Proyecto modular y ordenado que permite instalar y configurar cada tecnología paso a paso con scripts independientes, seguros y comentados.

## 🖼️ Vista Previa (estructura del proyecto)

```bash
.
├── README.md
└── scripts
    ├── 01-instalacion-base.sh
    ├── 02-instalar-zsh.sh
    ├── 03-configurar-zsh.sh
    ├── 04-instalar-git.sh
    ├── 05-instalar-ssh.sh
    ├── 06-instalar-ruby.sh
    ├── 07-instalar-node.sh
    ├── 08-instalar-python.sh
    ├── 09-instalar-java.sh
    ├── 10-instalar-postgresql.sh
    └── 11-instalar-docker.sh
    └── 12-instalar-terraform.sh
    └── 13-instalar-kubernetes.sh
```

## ⚙️ Requisitos

- Archlinux
- Conexión a internet
- Permisos de superusuario (`sudo`)
- Terminal con `bash` o `zsh`
- `tree` (opcional, para visualizar estructura)

## 🚀 Instalación paso a paso

```bash
git clone https://github.com/brayandiazc/dev-setup-ubuntu-es.git
cd dev-setup-ubuntu-es
chmod +x scripts/*.sh  # Otorga permisos de ejecución a todos los scripts
```

- Ejecuta el script base (instala librerías esenciales):

```bash
./scripts/01-instalacion-base.sh
```

- Luego puedes ejecutar, uno por uno, los scripts que necesites:

```bash
./scripts/02-instalar-zsh.sh
```

### 💡 Cierra la terminal, vuelve a abrirla y luego ejecuta

```bash
./scripts/03-configurar-zsh.sh
./scripts/04-instalar-git.sh
./scripts/05-instalar-ssh.sh
./scripts/06-instalar-ruby.sh
./scripts/07-instalar-node.sh
./scripts/08-instalar-python.sh
./scripts/09-instalar-java.sh
./scripts/10-instalar-postgresql.sh
./scripts/11-instalar-docker.sh
```

## 🔎 Scripts incluidos

| Nº  | Script                   | Descripción                                                     |
| --- | ------------------------ | --------------------------------------------------------------- |
| 01  | `instalacion-base.sh`    | Actualiza el sistema y prepara el entorno base                  |
| 02  | `instalar-zsh.sh`        | Instala `zsh` como shell predeterminada                         |
| 03  | `configurar-zsh.sh`      | Instala Oh My Zsh + plugins (tras reiniciar terminal)           |
| 04  | `instalar-git.sh`        | Instala Git y configura usuario, correo, y plantilla de commit  |
| 05  | `instalar-ssh.sh`        | Genera claves SSH para autenticación con GitHub                 |
| 06  | `instalar-ruby.sh`       | Instala Ruby usando `rbenv` con versión seleccionable           |
| 07  | `instalar-node.sh`       | Instala Node.js usando `nodenv` con versión estable por defecto |
| 08  | `instalar-python.sh`     | Instala Python con `pyenv` y paquetes esenciales                |
| 09  | `instalar-java.sh`       | Instala Java LTS + Maven con `sdkman`                           |
| 10  | `instalar-postgresql.sh` | Instala PostgreSQL desde el repositorio oficial (v16/v17)       |
| 11  | `instalar-docker.sh`     | Instala Docker y Docker Compose                                 |

## 🧪 Recomendación de uso

Usa los scripts en orden secuencial solo si estás configurando un sistema desde cero.
También puedes ejecutar solo los que necesites de forma independiente.

## 🖇️ Contribuye

```bash
# Fork → Crea rama → Cambios → Commit → Pull Request
```

Lee [CONTRIBUTING.md](.github/CONTRIBUTING.md) para más detalles.

## 📄 Licencia

MIT — ver [LICENSE](LICENSE.md)

---

⌨️ con ❤️ por [Brayan Diaz C](https://github.com/brayandiazc)
