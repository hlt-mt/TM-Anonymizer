FROM python:3.6


# Create app directory
WORKDIR /server

# Install dependencies
RUN git clone https://github.com/deepmipt/DeepPavlov.git
RUN ( cd DeepPavlov ; git checkout 69d5ee44 )
RUN python -m pip install --upgrade pip setuptools
RUN pip install deeppavlov
RUN pip install gast==0.2.2
RUN python -m deeppavlov install ner_ontonotes_bert
RUN pip show deeppavlov

# Copy needed files
COPY CMD.httpserver_start.sh /server
RUN mkdir -p /server/WWW /server/keywords
COPY WWW/. /server/WWW/
COPY keywords/. /server/keywords
COPY httpserver.py /server
COPY ta.py /server
RUN mkdir -p /root/.deeppavlov /root/nltk_data
COPY .deeppavlov/. /root/.deeppavlov
COPY nltk_data/. /root/nltk_data
## RUN ls -la /server/WWW
## RUN ls -la /server

# define the port number the container should expose
EXPOSE 8080

# run the command
CMD ["bash", "CMD.httpserver_start.sh"]
## CMD ["python3", "-u", "httpserver.py", "8080", "WWW", "debug"]

