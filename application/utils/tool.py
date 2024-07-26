import datetime
import decimal
import json
import time
import hashlib

# customer json encoder
class NewEncoder(json.JSONEncoder):
    def default(self, obj):
        if hasattr(obj, '__json__'):
            return obj.__json__()
        elif isinstance(obj, datetime.datetime):
            return obj.strftime("%Y-%m-%d %H:%M:%S")
        elif isinstance(obj, datetime.date):
            return obj.strftime("%Y-%m-%d")
        elif isinstance(obj, decimal.Decimal):
            return float(obj)
        else:
            return str(obj)


def jsonify(data):
    """
    format json
    """
    return json.dumps(data, cls=NewEncoder)


def jsonResponse(code=500, msg='error', data=None):
    """
        format json
    """
    if data is None:
        data = []
    return json.dumps({"code": code, "msg": msg, "data": data}, cls=NewEncoder)


def md5(string=''):
    """
    md5 function
    """
    if not string:
        return
    return hashlib.md5(string.encode("utf-8")).hexdigest()


def get_date():
    """
    get today date
    :return:
    """
    return time.strftime('%Y-%m-%d', time.localtime())


def get_date_time():
    """
    get current time
    :return:
    """
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())


def read_book_page(file, page=1, size=500):
    with open(file, 'r', encoding='utf-8') as file:
        content = file.read()
        start_index = size * (page - 1)
        end_index = min(start_index + size, len(content))
        progress = float(start_index / len(content) * 100)
        return content[start_index:end_index], progress
