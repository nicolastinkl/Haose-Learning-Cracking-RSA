import base64
from Crypto.Cipher import AES


def decrypt_image(img_data):
    key = base64.b64decode("1V6WW9fMB2MAPOVOD2DRfw==")
    generator = AES.new(key, AES.MODE_ECB)
    recovery = generator.decrypt(img_data)
    img_stream = base64.b64encode(recovery).decode()
    return recovery


def decrypt_video(img_data):
    key = base64.b64decode("TwtsEgjErnXRwOo1ofUQ2g==")
    generator = AES.new(key, AES.MODE_ECB)
    plain_text = generator.decrypt(img_data)
    plain_text = plain_text[:-int(plain_text[-1])]
    ne = plain_text.decode('utf-8')
    # img_stream = base64.b64encode(recovery).decode()
    return ne

