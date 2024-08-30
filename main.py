from flask import Flask, redirect, render_template
from flask_sqlalchemy import SQLAlchemy

#mydatabase connection
local_server=True
app=Flask(__name__)
app.secret_key="soham"


# app.config['SQLAlchemy_DATABASE_URI']='mysql://root:password@localhost/covid'

app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/'
db=SQLAlchemy(app)

class Test(db.Model):
    id=db.Column(db.Integer, primary_key=True)
    name=db.Column(db.String(50))


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/usersignup")
def usersignup():
    return render_template("usersignup.html")

@app.route("/userlogin")
def userlogin():
    return render_template("userlogin.html")


#testing whether db is connected or not
@app.route("/test")
def test():
    try:
        a = Test.query.all()
        print(a)
        return 'My database is connected {a.name}'
    except Exception as e:
        print(e)
        return f'My database is not connected {e}'


app.run(debug=True)