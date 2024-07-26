from flask import Flask
from flask_cors import CORS
from application.model.models import db
from application.controller.web import webapp
from application.controller.api import router
from application.utils.tool import NewEncoder

# create app
app = Flask(__name__, static_folder='dist', static_url_path='')

# SQLAlchemy config
# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:Yaphp1996qqcaoyang@39.103.201.117:3306/bookactivity'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:root@127.0.0.1:3306/bookactivity'
# app.config['SQLALCHEMY_ECHO'] = True
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
    'pool_size': 20,
    'pool_timeout': 7200,
    'pool_pre_ping': True,
    'pool_recycle': -1,
}

# secret key
app.secret_key = "blog"

# json encoder
app.json_encoder = NewEncoder

# register blueprint
# 当用户访问这些路径时，相应的蓝图将处理请求
app.register_blueprint(webapp, url_prefix='/')
app.register_blueprint(router, url_prefix='/api')

# enable CORS
CORS(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=True)

# init db
db.init_app(app)

if __name__ == '__main__':
    app.run(port=5000, debug=True)
