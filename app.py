from flask import Flask, render_template, request, redirect

app = Flask(__name__)

reservations = []

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/reserve')
def reserve():
    return render_template('reserve.html')

@app.route('/list')
def list_page():
    return render_template('list.html', reservations=reservations)

@app.route('/add', methods=['POST'])
def add():
    reservations.append({
        "name": request.form['name'],
        "car": request.form['car'],
        "date": request.form['date']
    })
    return redirect('/list')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
