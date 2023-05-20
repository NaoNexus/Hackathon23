import base64
import os


class FileHelper:
    def __init__(self):
        pass

    def decode_image(self, base64_image, path):
        image_64_decode = base64.b64decode(base64_image)
        # create a writable image and write the decoding result
        with open(path, 'wb') as file:
            file.write(image_64_decode)

    def encode_image(self, path):
        if (os.path.exists(path)):
            with open(path, 'rb') as file:
                file_content = file.read()
                return base64.b64encode(file_content)
        return ''

    def save_beach_report_images(self, report):
        os.makedirs(os.path.dirname(f'images/{report["id"]}/'), exist_ok=True)

        if (report.get('dirtyImage', '') != ''):
            self.decode_image(
                report['dirtyImage'], f'images/{report["id"]}/dirty.{report.get("dirtyImageExtension", "jpeg")}')

        if (report.get('cleanImage', '') != ''):
            self.decode_image(
                report['cleanImage'], f'images/{report["id"]}/clean.{report["cleanImageExtension"]}')

    def get_beach_report_images(self, report):
        if (report.get('dirtyImageExtension', '') != ''):
            report['dirtyImage'] = self.encode_image(
                f'images/{report["id"]}/dirty.{report.get("dirtyImageExtension", "jpeg")}')

        if (report.get('cleanImageExtension', '') != ''):
            report['cleanImage'] = self.encode_image(
                f'images/{report["id"]}/clean.{report["cleanImageExtension"]}')

        return report
