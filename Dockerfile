FROM amazonlinux:2
EXPOSE 8080
COPY webserver.py /opt/webserver.py
CMD ["python","/opt/webserver.py"]
