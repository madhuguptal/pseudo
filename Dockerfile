FROM amazonlinux:2
EXPOSE 8080
COPY webserver.py index.htm /
CMD ["python","/webserver.py"]
