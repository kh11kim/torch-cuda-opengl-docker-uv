## torch-cuda-opengl-uv-mujoco Docker example

This repository contains a CUDA-based Docker image for MuJoCo / OpenGL workloads.

### Build

```bash
./build.sh
```

### Run

```bash
./run.sh
```

`run.sh` enables GPU rendering with:

```bash
--gpus all
-e NVIDIA_DRIVER_CAPABILITIES=all
-e NVIDIA_VISIBLE_DEVICES=all
```

It also sets `--shm-size=16g` for simulation workloads.

### Rendering behavior

- Without the NVIDIA runtime options above, simulator image rendering may fall back to CPU rendering inside Docker.
- This image installs `libglvnd` / EGL packages and creates `/usr/share/glvnd/egl_vendor.d/10_nvidia.json` so EGL resolves to `libEGL_nvidia.so.0`.
- The container defaults to:

```bash
MUJOCO_GL=egl
PYOPENGL_PLATFORM=egl
__EGL_VENDOR_LIBRARY_DIRS=/usr/share/glvnd/egl_vendor.d
__GLX_VENDOR_LIBRARY_NAME=nvidia
```

### Quick verification in the container

After your environment creates an OpenGL context, verify the active renderer:

```python
from OpenGL.GL import glGetString, GL_VENDOR, GL_RENDERER

print(glGetString(GL_VENDOR).decode("utf-8"))
print(glGetString(GL_RENDERER).decode("utf-8"))
```

- CPU fallback example: `llvmpipe`
- Expected GPU rendering: `NVIDIA RTX ...`
