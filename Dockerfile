FROM python:3.9.7

WORKDIR /project
COPY requirements.txt .

# ENV FLASK_APP=main.py
# ENV FLASK_RUN_HOST=0.0.0.0
RUN pip install -r requirements.txt
EXPOSE 5000
COPY main.py .
CMD ["python","main.py"]