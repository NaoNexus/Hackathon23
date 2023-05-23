from helpers.config_helper import Config
from helpers.db_helper import DB
from helpers.logging_helper import logger

import utilities
import time
import os

from flask import Flask, request, current_app, jsonify, render_template, redirect, send_from_directory

app = Flask(__name__)


@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers',
                         'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods',
                         'GET,PUT,POST,DELETE,OPTIONS')
    return response

# Web App calls


@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')


'''@app.route('/reports', methods=['GET'])
def reports_screen():
    reports = db_helper.get_reports()

    return render_template('reports.html', reports=reports)


@app.route('/new_report', methods=['GET'])
def new_report_screen():
    report = {'id': '', 'date': '', 'co2': 0, 'temperature': 0,
              'humidity': 0, 'nPeople': 0, 'internalLight': 0, 'externalLight': 0}
    return render_template('report.html', report=report)


@app.route('/report/<id>', methods=['GET'])
def report_screen(id):
    if (id != None and id != ''):
        try:
            report = db_helper.get_report(id)
            return render_template('report.html', report=report)
        except Exception as e:
            logger.error(str(e))
            return redirect("/reports", code=500)

    return redirect("/reports", code=404)'''


@app.route('/images/<path:filename>', methods=['GET', 'POST'])
def download(filename):
    try:
        print(os.path.dirname(app.instance_path))
        uploads = os.path.join(os.path.dirname(app.instance_path), 'images/')
        logger.info(uploads)
        return send_from_directory(uploads, filename)
    except Exception as e:
        logger.error(e)

# Api calls
# Reports calls


@app.route('/api/info', methods=['GET'])
def info():
    return jsonify({'code': 200, 'status': 'online', 'elapsed time': utilities.getElapsedTime(startTime)}), 200


@app.route('/api/login', methods=['POST'])
def login():
    try:
        json = request.json
        if (json.get('nickname', '') != '' and json.get('password', '') != ''):
            result = db_helper.get_user_by_nickname_and_password(
                json['nickname'], json['password'])
            if (result == {}):
                logger.error('Nickname or password wrong')
                return jsonify({'code': 500, 'message': 'Nickname or password wrong'}), 500
            return jsonify({'code': 200, 'message': 'OK', 'data': result}), 200
        else:
            logger.error('No nickname argument or password argument passed')
            return jsonify({'code': 500, 'message': 'No nickname or password was passed'}), 500
    except Exception as e:
        logger.error(str(e))
        return jsonify({'code': 500, 'message': str(e)}), 500


@app.route('/api/check_username', methods=['GET'])
def check_username():
    try:
        json = request.json
        if (json.get('nickname', '') != ''):
            result = db_helper.get_user_by_nickname(
                json['nickname'])
            if (result == {}):
                logger.error('Nickname already present')
                return jsonify({'code': 500, 'message': 'Nickname already present'}), 500
            return jsonify({'code': 200, 'message': 'OK', 'data': result}), 200
        else:
            logger.error('No nickname argument passed')
            return jsonify({'code': 500, 'message': 'No nickname was passed'}), 500
    except Exception as e:
        logger.error(str(e))
        return jsonify({'code': 500, 'message': str(e)}), 500


@app.route('/api/register', methods=['POST'])
def register():
    try:
        json = request.json
        print(json)
        if (json.get('nickname', '') != '' and json.get('password', '') != ''):
            result = db_helper.get_user_by_nickname(json['nickname'])
            if (result != {}):
                logger.error('Nickname already present')
                return jsonify({'code': 500, 'message': 'Nickname already present'}), 500
            return jsonify({'code': 200, 'message': 'OK', 'data': db_helper.save_user(json)}), 200
        else:
            logger.error('No nickname argument or password argument passed')
            return jsonify({'code': 500, 'message': 'No nickname or password was passed'}), 500
    except Exception as e:
        logger.error(str(e))
        return jsonify({'code': 500, 'message': str(e)}), 500


@app.route('/api/report', methods=['POST'])
def save_beach_report():
    try:
        if request.content_type == 'application/json':
            json = request.json
        else:
            json = request.form.to_dict()
        
        return jsonify({'code': 201, 'message': 'OK', 'data': db_helper.save_beach_report(json, request.files.get('dirtyImage', ''), request.files.get('cleanImage', ''))}), 201
    except Exception as e:
        logger.error(str(e))
        if request.content_type == 'application/json':
            return jsonify({'code': 500, 'message': str(e)}), 500
        return redirect("/reports", code=500)


@app.route('/api/report/<id>', methods=['GET', 'POST', 'DELETE'])
def report(id):
    if (id != None and id != ''):
        if request.method == 'GET':
            try:
                return jsonify({'code': 200, 'message': 'OK', 'data': db_helper.get_beach_report(id)}), 200
            except Exception as e:
                logger.error(str(e))
                return jsonify({'code': 500, 'message': str(e)}), 500
        elif request.method == 'POST':
            try:
                if request.content_type == 'application/json':
                    json = request.json
                else:
                    json = request.form.to_dict()
                json['id'] = id
                if request.content_type == 'application/json':
                    return jsonify({'code': 201, 'message': 'OK', 'data': db_helper.save_beach_report(json, request.files['dirtyImage'], request.files['cleanImage'])}), 201
                else:
                    db_helper.save_beach_report(json)
                    return redirect("/reports", code=302)
            except Exception as e:
                logger.error(str(e))
                if request.content_type == 'application/json':
                    return jsonify({'code': 500, 'message': str(e)}), 500
                return redirect("/reports", code=500)
        elif request.method == 'DELETE':
            try:
                return jsonify({'code': 201, 'message': 'OK', 'data': db_helper.delete_beach_report(id)}), 201
            except Exception as e:
                logger.error(str(e))
                return jsonify({'code': 500, 'message': str(e)}), 500
    else:
        logger.error('No id argument passed')
        return jsonify({'code': 500, 'message': 'No id was passed'}), 500


@app.route('/api/reports', methods=['GET'])
def reports():
    try:
        return jsonify({'code': 200, 'message': 'OK', 'data': db_helper.get_beaches_reports()}), 200
    except Exception as e:
        logger.error(str(e))
        return jsonify({'code': 500, 'message': str(e)}), 500


if __name__ == '__main__':
    config_helper = Config()
    db_helper = DB(config_helper)

    startTime = time.time()

    app.run(host=config_helper.srv_host, port=config_helper.srv_port,
            debug=config_helper.srv_debug)
