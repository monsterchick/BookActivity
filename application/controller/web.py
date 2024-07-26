from flask import redirect
from flask import Blueprint

webapp = Blueprint('webapp', __name__)


@webapp.get("/")
def home():
    """
    首页
    :return:
    """
    return redirect("/index.html")
