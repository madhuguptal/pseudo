FROM amazonlinux:2
EXPOSE 8080
COPY webserver.py index.htm /opt/
CMD ["python","/opt/webserver.py"]
