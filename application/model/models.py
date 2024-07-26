from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(32), nullable=False)
    password = db.Column(db.String(32), nullable=False)
    role = db.Column(db.Integer, default=1)
    email = db.Column(db.String(50), nullable=False)
    phone = db.Column(db.String(32), nullable=False)
    avatar = db.Column(db.String(255), default='/uploads/avatar/avatar.png')
    create_at = db.Column(db.DateTime, default=db.func.now())

    def __json__(self):
        return {
            'id': self.id,
            'username': self.username,
            'password': self.password,
            'role': self.role,
            'email': self.email,
            'phone': self.phone,
            'avatar': self.avatar,
            'create_at': self.create_at.strftime('%Y-%m-%d %H:%M:%S')
        }


class Book(db.Model):
    __tablename__ = 'book'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    cover = db.Column(db.String(255), nullable=False)
    author = db.Column(db.String(50), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    summary = db.Column(db.String(255), nullable=False)
    file = db.Column(db.String(255), nullable=False)

    def __json__(self):
        return {
            'id': self.id,
            'title': self.title,
            'cover': self.cover,
            'author': self.author,
            'category': self.category,
            'summary': self.summary,
            'file': self.file
        }


class Activity(db.Model):
    __tablename__ = 'activity'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    start_date = db.Column(db.DateTime, nullable=False)
    end_date = db.Column(db.DateTime, nullable=False)

    def __json__(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'type': self.type,
            'start_date': self.start_date.strftime('%Y-%m-%d %H:%M:%S'),
            'end_date': self.end_date.strftime('%Y-%m-%d %H:%M:%S'),
        }


class Logs(db.Model):
    __tablename__ = 'logs'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    type = db.Column(db.String(30), nullable=False)
    content = db.Column(db.Text, nullable=False)
    create_at = db.Column(db.DateTime, default=db.func.now())

    def __json__(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'content': self.content,
            'type': self.type,
            'create_at': self.create_at.strftime('%Y-%m-%d %H:%M:%S')
        }


class Comment(db.Model):
    __tablename__ = 'comment'

    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    comment = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.now())
    updated_at = db.Column(db.DateTime, default=db.func.now(), onupdate=db.func.now())

    user = relationship('User')

    def __json__(self):
        return {
            'id': self.id,
            'book_id': self.book_id,
            'user_id': self.user_id,
            'comment': self.comment,
            'user': self.user.__json__(),
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        }


class Progress(db.Model):
    __tablename__ = 'progress'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'), nullable=False)
    progress = db.Column(db.Float, nullable=False)

    def __json__(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'book_id': self.book_id,
            'progress': self.progress
        }


class Record(db.Model):
    __tablename__ = 'record'

    id = db.Column(db.Integer, primary_key=True)
    activity_id = db.Column(db.Integer, db.ForeignKey('activity.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    type = db.Column(db.String(50))
    value = db.Column(db.Integer, default=0)

    user = relationship('User')

    def __json__(self):
        return {
            'id': self.id,
            'activity_id': self.activity_id,
            'user_id': self.user_id,
            'user': self.user.__json__(),
            'type': self.type,
            'value': self.value
        }
