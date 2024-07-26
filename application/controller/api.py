from flask import session, current_app as app
from flask import Blueprint
from flask import request
from sqlalchemy import or_
from application.utils.tool import *
from application.model.models import *
from datetime import datetime

router = Blueprint('router', __name__)


def logger(user: int, type: str, content: str):
    """
    save user log or notice
    :return:
    """
    res = Logs(user_id=user, type=type, content=content, create_at=get_date_time())
    db.session.add(res)
    db.session.commit()
    return res.id


def save_user_record(user_activities, progress, current_progress):
    """
    :return:
    """
    if "read_start_time" not in session:
        session['read_start_time'] = time.time()

    # Query for activities in which users participated
    user_activity_ids = [record.activity_id for record in user_activities]

    app.logger.info(f"user_activity_ids: {user_activity_ids}")

    # Query for active activities
    activities = Activity.query.filter(
        Activity.start_date <= datetime.now(),
        Activity.end_date >= datetime.now(),
        Activity.id.in_(user_activity_ids)
    ).all()

    # Valid active IDS
    activity_ids = [activity.id for activity in activities]

    # Take the intersection of the user's participation activity and the valid activity ID
    records = [record for record in user_activities if record.activity_id in activity_ids]

    app.logger.info(f"activity_ids: {activity_ids}")

    for record in records:
        if record.type == 'TimeBased':
            read_time = time.time() - session['read_start_time']
            record.value += read_time
            app.logger.info(f"read time: {read_time}")
            db.session.commit()

        if record.type == 'QuantityBased':
            app.logger.info(f"progress: {progress}")
            if progress >= 100 > current_progress:
                record.value += 1
                db.session.commit()


@router.before_request
def before_request():
    """
    Check login status
    :return:
    """
    if request.path == '/api/login' or request.path == '/api/register':
        return

    if request.method in ["POST", "PUT", "DELETE"] and 'user' not in session:
        return jsonResponse(401, 'Please login first')


@router.after_request
def after_request(response):
    """
    Close request session
    :param response:
    :return:
    """
    # db.session.remove()
    return response


@router.post('/upload')
def post_upload():
    if not request.files['file'] or request.files['file'] == '':
        return jsonResponse(500, "Not found file")
    file = request.files['file']#flask-request method

    if "." not in file.filename:
        return jsonResponse(500, "Not found file type")

    file_type = file.filename.split(".")[-1]
    save_name = md5(file.filename + str(time.time())) + '.' + file_type# generate unit name

    if file_type == 'txt':
        save_path = '/dist/uploads/book/' + save_name
    else:
        save_path = '/dist/uploads/avatar/' + save_name
    file.save(app.root_path + save_path)
    return jsonResponse(200, "upload success", save_path.replace("/dist", ""))


@router.post("/login")
def post_login():
    """
    User login
    :return: json
    """
    data = request.get_json()

    username = data.get("username")
    password = data.get("password")

    user = User.query.filter(
        or_(User.username == username, User.email == username),
        User.password == password
    ).first()

    if not user:
        return jsonResponse(500, "The account or password is incorrect")

    # save log
    logger(user.id, "Login", "login success, ip:" + request.environ.get('HTTP_X_REAL_IP', request.remote_addr))

    # save user info in session
    session['user'] = user.__json__()
    return jsonResponse(200, "Success", user)


@router.post("/register")
def post_register():
    """
     user register
    :return:
    """
    data = request.get_json()

    # check field
    required_fields = ['username', 'password', 'email', 'phone']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Miss field: {', '.join(missing_fields)}")

    user = User(**{k: data[k] for k in required_fields})
    db.session.add(user)
    db.session.commit()

    # check user id
    if user.id:
        return jsonResponse(200, 'Register success', None)
    return jsonResponse(500, 'Register failed', user)


@router.get("/user")
def get_user():
    """
    get user
    :return:
    """
    username = request.args.get("username")
    email = request.args.get("email")
    phone = request.args.get("phone")

    page = request.args.get("pageNo", 1)
    limit = request.args.get("pageSize", 10)

    # inquire
    query = User.query.order_by(User.id.desc())

    # Conditional queries
    if username:
        query = query.filter(User.username.contains(username))

    if email:
        query = query.filter(User.email.contains(email))

    if phone:
        query = query.filter(User.phone.contains(phone))

    res = query.paginate(page=int(page), per_page=int(limit), max_per_page=100, error_out=False)

    data = {
        "list": res.items,
        "total": res.total
    }
    return jsonResponse(200, "success", data)


@router.post("/user")
def post_user():
    """
    Add user
    :return:
    """
    data = request.get_json()

    # Verify that all the necessary fields are included in the request
    required_fields = ['username', 'password', 'email', 'phone', 'avatar']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Required fields are missing: {', '.join(missing_fields)}")

    # Create an instance of the problem and assign a value using the dictionary unwrap
    user = User(**{k: data[k] for k in required_fields})
    db.session.add(user)
    db.session.commit()

    return jsonResponse(200, 'The addition was successful', None)


@router.put("/user")
def put_user():
    """
    Update user
    :return:
    """
    data = request.get_json()
    user = User.query.filter_by(id=data.get("id")).first()

    if not user:
        return jsonResponse(500, 'User not found')

    user.username = data.get("username")
    user.password = data.get("password")
    user.email = data.get("email")
    user.phone = data.get("phone")
    user.avatar = data.get("avatar")

    db.session.commit()
    return jsonResponse(200, 'Update Success', None)


@router.delete("/user")
def delete_user():
    """
    Delete user
    :return:
    """
    ids = request.args.get("id")

    if not ids:
        return jsonResponse(500, 'Params Error')

    ids = ids.split(',')

    res = User.query.filter(
        User.id.in_(ids)
    ).delete()

    db.session.commit()

    if not res:
        return jsonResponse(500, 'Delete Failed')

    return jsonResponse(200, 'Delete Success', None)


@router.get("/book")
def get_book():
    """
    Get book
    :return:
    """
    title = request.args.get("title")
    author = request.args.get("author")
    category = request.args.get("category")

    page = request.args.get("page", 1)
    limit = request.args.get("limit", 10)
    all = request.args.get("all")

    # inquire
    query = Book.query.order_by(Book.id.asc())

    # Conditional queries
    if title:
        query = query.filter(Book.title.contains(title))

    if author:
        query = query.filter(Book.author.contains(author))

    if category:
        query = query.filter(Book.category.contains(category))

    if all:
        res = query.all()
        return jsonResponse(200, "success", res)

    res = query.paginate(page=int(page), per_page=int(limit), max_per_page=100, error_out=False)

    data = {
        "list": res.items,
        "total": res.total
    }
    return jsonResponse(200, "success", data)


@router.get("/book/search")
def get_book_search():
    """
    Get book
    :return:
    """
    keyword = request.args.get("keyword")

    # search
    query = Book.query.order_by(Book.id.asc()).filter(
        or_(
            Book.id == keyword,
            Book.title.contains(keyword),
            Book.author.contains(keyword),
            Book.category.contains(keyword)
        )
    ).all()

    if not query:
        return jsonResponse(500, 'Book not found')

    if len(query) == 1:
        comments = Comment.query.filter_by(book_id=query[0].id).order_by(Comment.id.desc()).all()
    else:
        comments = []

    data = {
        "book": query,
        "comments": comments
    }
    return jsonResponse(200, "success", data)


@router.post("/book")
def post_book():
    """
    Add book
    :return:
    """
    data = request.get_json()

    # Verify that all the necessary fields are included in the request
    required_fields = ['title', 'cover', 'author', 'category', 'summary', 'file']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Required fields are missing: {', '.join(missing_fields)}")

    # Create an instance of the problem and assign a value using the dictionary unwrap
    book = Book(**{k: data[k] for k in required_fields})
    db.session.add(book)
    db.session.commit()

    if book.id > 0:
        users = User.query.all()
        for user in users:
            logs = Logs(
                user_id=user.id,
                type='New Book',
                content=f'{book.title},AVAILABLE'
            )
            db.session.add(logs)
            db.session.commit()

    return jsonResponse(200, 'The addition was successful', None)


@router.put("/book")
def put_book():
    """
    Update book
    :return:
    """
    data = request.get_json()
    book = Book.query.filter_by(id=data.get("id")).first()

    if not book:
        return jsonResponse(500, 'Book not found')

    # Verify that all the necessary fields are included in the request
    required_fields = ['id', 'title', 'cover', 'author', 'category', 'summary', 'file']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Miss field: {', '.join(missing_fields)}")

    if 'title' in data:
        book.title = data['title']
    if 'cover' in data:
        book.cover = data['cover']
    if 'author' in data:
        book.author = data['author']
    if 'category' in data:
        book.category = data['category']
    if 'summary' in data:
        book.summary = data['summary']
    if 'file' in data:
        book.file = data['file']

    db.session.commit()
    return jsonResponse(200, 'Update Success', None)


@router.delete("/book")
def delete_book():
    """
    Delete book
    :return:
    """
    ids = request.args.get("id")

    if not ids:
        return jsonResponse(500, 'Params Error')

    ids = ids.split(',')

    res = Book.query.filter(
        Book.id.in_(ids)
    ).delete()

    db.session.commit()

    if not res:
        return jsonResponse(500, 'Delete Failed')

    return jsonResponse(200, 'Delete Success', None)


@router.get("/activity")
def get_activity():
    """
    Get activity
    :return:
    """
    title = request.args.get("title")
    type = request.args.get("type")
    page = request.args.get("page", 1)# by default  1 page
    limit = request.args.get("limit", 10)# by default 10 page
    id = request.args.get("id")
    all = request.args.get("all")

    # 该函数是一个数据库查询操作，属于SQLAlchemy ORM
    # inquire
    query = Activity.query.order_by(Activity.id.asc())

    # Conditional queries
    if title:
        query = query.filter(Activity.title.contains(title))

    if type:
        query = query.filter(Activity.type.contains(type))

    if id:
        query = query.filter(Activity.id == id).first()

        rank = Record.query.filter_by(
            activity_id=id
        ).order_by(Record.value.asc()).all()

        data = {
            "activity": query,
            "ranks": rank
        }
        return jsonResponse(200, "success", data)

    if all:
        res = query.all()
        return jsonResponse(200, "success", res)

    res = query.paginate(page=int(page), per_page=int(limit), max_per_page=100, error_out=False)

    data = {
        "list": res.items,
        "total": res.total
    }
    return jsonResponse(200, "success", data)


@router.post("/activity")
def post_activity():
    """
    Add activity
    :return:
    """
    data = request.get_json()

    # Verify that all the necessary fields are included in the request
    required_fields = ['title', 'description', 'type', 'start_date', 'end_date']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Required fields are missing: {', '.join(missing_fields)}")

    # Create an instance of the problem and assign a value using the dictionary unwrap
    activtiy = Activity(**{k: data[k] for k in required_fields})
    db.session.add(activtiy)
    db.session.commit()

    if activtiy.id > 0:
        users = User.query.all()
        for user in users:
            logs = Logs(
                user_id=user.id,
                type='New Activity',
                content=f'{activtiy.title},The event has begun'
            )
            db.session.add(logs)
            db.session.commit()

    return jsonResponse(200, 'The addition was successful', None)


@router.put("/activity")
def put_activity():
    """
    Update activity
    :return:
    """
    data = request.get_json()
    book = Activity.query.filter_by(id=data.get("id")).first()

    if not book:
        return jsonResponse(500, 'Activity not found')

    # Verify that all the necessary fields are included in the request
    required_fields = ['id', 'title', 'description', 'type', 'start_date', 'end_date']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Miss field: {', '.join(missing_fields)}")

    if 'title' in data:
        book.title = data['title']
    if 'description' in data:
        book.description = data['description']
    if 'type' in data:
        book.type = data['type']
    if 'start_date' in data:
        book.start_date = data['start_date']
    if 'end_date' in data:
        book.end_date = data['end_date']

    db.session.commit()
    return jsonResponse(200, 'Update Success', None)


@router.delete("/activity")
def delete_activity():
    """
    Delete activity
    :return:
    """
    ids = request.args.get("id")

    if not ids:
        return jsonResponse(500, 'Params Error')

    ids = ids.split(',')

    res = Activity.query.filter(
        Activity.id.in_(ids)
    ).delete()

    db.session.commit()

    if not res:
        return jsonResponse(500, 'Delete Failed')

    return jsonResponse(200, 'Delete Success', None)


@router.get("/activity/status")
def get_activity_status():
    """
    user sign up status
    :return:
    """
    data = request.args.to_dict()

    if not data.get('user_id') or not data.get('activity_id'):
        return jsonResponse(500, 'Params Error')

    status = Record.query.filter_by(user_id=data.get('user_id'), activity_id=data.get('activity_id')).first()

    count = Record.query.filter_by(activity_id=data.get('activity_id')).count()

    data = {
        "count": count,
        "status": status
    }

    return jsonResponse(200, 'success', data)


@router.post("/activity/signup")
def post_activity_signup():
    """
    Add book
    :return:
    """
    data = request.get_json()

    activity = Activity.query.filter_by(id=data.get('activity_id')).first()
    if not activity:
        return jsonResponse(500, 'Activity not found')

    if activity.start_date > datetime.now():
        return jsonResponse(500, 'Activity not started')

    if activity.end_date < datetime.now():
        return jsonResponse(500, 'Activity has ended')

    status = Record.query.filter_by(user_id=data.get('user_id'), activity_id=data.get('activity_id')).first()

    if status:
        return jsonResponse(500, 'Already signed up')

    # Verify that all the necessary fields are included in the request
    required_fields = ['activity_id', 'user_id', 'type']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Required fields are missing: {', '.join(missing_fields)}")

    # Create an instance of the problem and assign a value using the dictionary unwrap
    record = Record(**{k: data[k] for k in required_fields})
    db.session.add(record)
    db.session.commit()

    return jsonResponse(200, 'The addition was successful', None)


@router.get('/chapter')
def get_chapter():
    book_id = request.args.get("book_id")
    file = request.args.get('file')
    page = request.args.get('page', 1, type=int)
    size = request.args.get('size', 500, type=int)

    user = session['user']
    try:
        file_path = app.root_path + '/dist' + file
        content, progress = read_book_page(file_path, page, size)

        # save progress
        found = Progress.query.filter_by(user_id=user["id"], book_id=book_id).first()

        current_progress = found.progress if found else 0

        if found is None:
            user_progress = Progress(user_id=user["id"], book_id=book_id, progress=progress)
            db.session.add(user_progress)
            db.session.commit()
        else:
            if found.progress < progress:
                if progress > 100:
                    progress = 100
                found.progress = round(progress, 2)
                db.session.commit()

        # save user record
        user_activity = Record.query.filter_by(user_id=user["id"]).all()

        if user_activity:
            save_user_record(user_activity, progress, current_progress)

        return jsonResponse(200, 'success', {
            'content': content,
            'progress': str(round(progress, 2)) + '%'
        })
    except Exception as e:
        return jsonResponse(500, f'Error reading page {page}: {str(e)}')


@router.post("/comment")
def post_comment():
    """
    Add comment
    :return:
    """
    data = request.get_json()

    # Verify that all the necessary fields are included in the request
    required_fields = ['book_id', 'user_id', 'comment']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Required fields are missing: {', '.join(missing_fields)}")

    # Create an instance of the problem and assign a value using the dictionary unwrap
    comment = Comment(**{k: data[k] for k in required_fields})
    db.session.add(comment)
    db.session.commit()

    return jsonResponse(200, 'The addition was successful', None)


@router.put("/comment")
def put_comment():
    """
    Update comment
    :return:
    """
    data = request.get_json()
    comment = Comment.query.filter_by(id=data.get("id")).first()

    if not comment:
        return jsonResponse(500, 'Comment not found')

    # Verify that all the necessary fields are included in the request
    required_fields = ['id', 'book_id', 'user_id', 'comment']
    missing_fields = [field for field in required_fields if not data.get(field)]
    if missing_fields:
        return jsonResponse(500, f"Miss field: {', '.join(missing_fields)}")

    if 'comment' in data:
        comment.author = data['comment']

    db.session.commit()
    return jsonResponse(200, 'Update Success', None)


@router.delete("/comment")
def delete_comment():
    """
    Delete comment
    :return:
    """
    ids = request.args.get("id")

    if not ids:
        return jsonResponse(500, 'Params Error')

    ids = ids.split(',')

    res = Comment.query.filter(
        Comment.id.in_(ids)
    ).delete()

    db.session.commit()

    if not res:
        return jsonResponse(500, 'Delete Failed')

    return jsonResponse(200, 'Delete Success', None)


@router.get("/logs")
def get_logs():
    """
    Get user logs
    :return:
    """
    user_id = session["user"]["id"]

    # search
    query = Logs.query.filter_by(user_id=user_id).order_by(Logs.id.desc()).all()

    if not query:
        return jsonResponse(500, 'Logs not found')

    data = {
        "list": query
    }
    return jsonResponse(200, "success", data)
