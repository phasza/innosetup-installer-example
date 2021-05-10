import os
import logging

version_file = ".\\config\\versionFile"
inno_setup_executable = ".\\tools\\innosetup\\ISCC.exe"
project_dir = ".\\src\\example-app"
installer_project_file = ".\\src\\installer\\installer.iss"

def build_project():
    logging.info(f"Building gradle project: {project_dir}")
    build_cmd = f"{project_dir}\gradlew.bat build -p {project_dir}"
    logging.info(f"Executing '{build_cmd}'")
    retVal = os.system(build_cmd)
    if retVal != 0:
        raise RuntimeError("Could not build example project!")

def create_installer():
    logging.info(f"Creating installer with inno setup: {inno_setup_executable}")
    version = read_version_file(version_file)
    logging.info(f"Version: {version}")
    innosetup_cmd = f"{inno_setup_executable} {installer_project_file} /DVersion={version}"
    logging.info(f"Executing '{innosetup_cmd}'")
    retVal = os.system(innosetup_cmd)
    if retVal != 0:
        raise RuntimeError("Could not create installer!")
    
def read_version_file(version_file):
    with open(version_file) as f:
        return f.read()

def main():
    logging.basicConfig(level=logging.INFO)
    try:
        build_project()
        create_installer()
    except RuntimeError as err:
        logging.error("Error during pipeline execution: {0}".format(err))
        
if __name__ == "__main__":
    main()