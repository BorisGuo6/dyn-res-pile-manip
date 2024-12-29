#!/bin/bash

CURR_CONDA=$CONDA_DEFAULT_ENV
CONDA_BASE=$(conda info --base)
docker pull xingyu/softgym
docker run \
    -v ${PWD}/PyFleX:/workspace/PyFleX \
    -v ${CONDA_PREFIX}:/workspace/anaconda \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -it xingyu/softgym:latest bash \
    -c "export PATH=/workspace/anaconda/bin:$PATH; cd /workspace/PyFleX; export PYFLEXROOT=/workspace/PyFleX; export PYTHONPATH=/workspace/PyFleX/bindings/build:$PYTHONPATH; export LD_LIBRARY_PATH=$PYFLEXROOT/external/SDL2-2.0.4/lib/x64:$LD_LIBRARY_PATH; cd bindings; mkdir build; cd build; /usr/bin/cmake ..; make -j"

# echo '' >> ~/.bashrc
# echo '# PyFleX' >> ~/.bashrc
# echo "export PYFLEXROOT=${PWD}/PyFleX" >> ~/.bashrc
# echo 'export PYTHONPATH=${PYFLEXROOT}/bindings/build:$PYTHONPATH' >> ~/.bashrc
# echo 'export LD_LIBRARY_PATH=${PYFLEXROOT}/external/SDL2-2.0.4/lib/x64:$LD_LIBRARY_PATH' >> ~/.bashrc
# echo '' >> ~/.bashrc

source ~/.bashrc
source $CONDA_BASE/etc/profile.d/conda.sh
conda activate $CURR_CONDA


docker run \
    -v ${PWD}/PyFleX:/workspace/PyFleX \
    -v ${CONDA_PREFIX}:/workspace/anaconda \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -it xingyu/softgym:latest bash \
    -c "export PATH=/workspace/anaconda/bin:$PATH; \
        export pybind11_DIR=/workspace/anaconda/lib/python3.9/site-packages/pybind11/share/cmake/pybind11; \
        cd /workspace/PyFleX; \
        export PYFLEXROOT=/workspace/PyFleX; \
        export PYTHONPATH=/workspace/PyFleX/bindings/build:$PYTHONPATH; \
        export LD_LIBRARY_PATH=$PYFLEXROOT/external/SDL2-2.0.4/lib/x64:$LD_LIBRARY_PATH; \
        cd bindings; \
        if [ ! -d 'build' ]; then mkdir build; fi; \
        cd build; \
        /usr/bin/cmake -Dpybind11_DIR=$pybind11_DIR ..; \
        make -j"
docker run \
    -v ${PWD}:/workspace/Engine \
    -v ${CONDA_PREFIX}:/workspace/anaconda \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -it xingyu/softgym:latest bash \
    -c "export PATH=/workspace/anaconda/bin:$PATH; \
        export pybind11_DIR=/workspace/anaconda/lib/python3.9/site-packages/pybind11/share/cmake/pybind11; \
        cd Engine; \
        python setup.py install"