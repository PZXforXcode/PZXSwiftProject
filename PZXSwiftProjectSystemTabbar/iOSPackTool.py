import subprocess
import requests

def build_ios_app():
    # 设置项目路径，相对路径，脚本和文件放在同一目录下
    project_path = "./PZXSwiftProject.xcworkspace"
    
    # 用户输入配置(Debug/Release)和版本号
    configuration = input("Enter configuration (Debug/Release): ").strip()
    new_version = input("Enter new version number(_Test/_Pre/_Dev): ").strip()

    # 更新版本号
    update_version_command = [
        "xcrun",
        "agvtool",
        "new-marketing-version",
        new_version
    ]
    subprocess.run(update_version_command)

    # 使用xcodebuild打包
    build_command = [
        "xcodebuild",
        "-workspace", project_path,
        "-scheme", "PZXSwiftProject",
        "-configuration", configuration,
        "-archivePath", "./iOSPack/PZXSwiftProject.xcarchive",
        "archive"
    ]
    subprocess.run(build_command)

    # 使用xcodebuild导出IPA
    export_command = [
        "xcodebuild",
        "-exportArchive",
        "-archivePath", "./iOSPack/PZXSwiftProject.xcarchive",
        "-exportOptionsPlist", "./exportOptions.plist",
        "-exportPath", "./iOSPack"
    ]
    subprocess.run(export_command)

    # 调用蒲公英API上传IPA文件
    pgyer_upload(api_key="e9f8563c95a396ecea6b6e597e2a3341", file_path="./iOSPack/PZXSwiftProject.ipa")

def pgyer_upload(api_key, file_path):
    upload_url = "https://www.pgyer.com/apiv2/app/upload"
    
    # 设置上传的参数s
    data = {
        "_api_key": api_key
    }
    
    # 使用 requests 发送 POST 请求
    with open(file_path, "rb") as file:
        files = {"file": (file_path, file)}
        response = requests.post(upload_url, data=data, files=files)
    
    # 打印上传结果
    print(response.text)

if __name__ == "__main__":
    # 执行构建和导出IPA，并上传到蒲公英
    build_ios_app()
