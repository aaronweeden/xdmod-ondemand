# Preparing a new version of the tool
1. Make sure the version number is updated in `tools/xdmod-ondemand-export/xdmod_ondemand_export/__init__.py`.
1. In `CHANGELOG.md`, add a section for the new version, and move the items from the "Main development branch" section to it.
1. Create a Pull Request for the new version.
1. Once the Pull Request is merged, tag the repository with the version number (e.g., `export-1.2.0`).

# Distributing the new version to PyPI
After the Pull Request is merged, these steps should be run from the `tools/xdmod-ondemand-export` directory.
1. Start up a virtual environment, e.g.:
    ```
    env_dir=~/xdmod-ondemand-export-build/env
    python3 -m venv ${env_dir}
    source ${env_dir}/bin/activate
    ```
1. Make sure the required packages are installed:
    ```
    python3 -m pip install --upgrade pip build setuptools twine
    ```
1. Clean out artifacts from any previous builds:
    ```
    rm -rf build/ dist/ xdmod_ondemand_export.egg-info/
    ```
1. Build the built distribution:
    ```
    python3 -m build --wheel
    ```
1. Upload the built distribution to PyPI, e.g., for version 1.1.0:
    ```
    version=1.1.0
    twine upload dist/xdmod_ondemand_export-${version}-py3-none-any.whl
    ```
    Enter your PyPI username and password.
