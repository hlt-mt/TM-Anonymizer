# TM-Anonymizer
This repository contains the software to run the Translation Memory anonymization service developed within the [CEF Data MarketPlace project](https://www.datamarketplace.eu). A service based on this tool is offered by the TAUS Data MarketPlace platform.

The goal of the tool is to protect private information possibly contained in TMs uploaded to the Marketplace. This is obtained by detecting Personally Identifiable Information (PII) in the source and target-language sides of a translation memory. 

A PII is any data that could potentially identify a specific individual. The PIIs identified by the tool are: 

person names, emails, URLs, phone numbers, credit card numbers, driver’s license numbers, identity card numbers, passport numbers, social security numbers, license plate numbers.


## The tool
The tool includes two different libraries to extract the required PIIs from the source and target language texts. 

Person names and addresses are extracted using the [DeepPavlov NER tool](https://docs.deeppavlov.ai/en/master/features/models/ner.html). It is a hybrid model based on [Multilingual BERT](https://docs.deeppavlov.ai/en/master/features/models/bert.html) adapted for the named entity recognition task. Among all the possible types of entities, our tool selects only the persons. 

All the other PIIs are obtained by in-house software based on regular expressions and language-specific knowledge and patterns.

The tool is able to extract PIIs in 24 languages: Albanian, Bulgarian, Croatian, Czech, Danish, Dutch, English, Finnish, French, German, Greek, Hungarian, Italian, Latvian, Lithuanian, Norwegian (Bokmal), Norwegian (Nynorsk), Polish, Portuguese, Romanian, Spanish, Slovak, Swedish, Turkish.

The tool is accessible by an API that allows a user to process one or multiple TUs at the time. More details about the API specifications are available below.


## Installation and Usage

The first step is to download the Docker image of the code [image.anonymization_service__v2.tar.gz](https://fbk.sharepoint.com/:u:/s/MTUnit/EXWYTg8zZ1NVAAPENE0T3ugBDh8WIwZt1jj0ypNpP-GDiA?e=eclGet) (around 3GB)

No specific hardware or software is required in addition to a working
"docker" installation (only the optional "email" functionality requires an email sending service running on the host)

Once the Docker image has been downloaded, it has to be added to your docker environment
```bash
$ docker load < image.anonymization_service__v2.tar.gz
```

To start the service, run the following command:
```bash
$ docker run --rm -it --net=host anonymization_service
```

The process prints different information, when it prints the message
```bash
web service ready at port 8080
```
this means it is ready to accept requests.

Requests can be issued at the following URLs:
* http://localhost:8080/anonymization_service.php
* http://${PUBLIC-IP}:8080/anonymization_service.php


### Example

The request
```bash
curl -X POST -F units='id1|en|credit card 5592-1234-5678-9876 of mr. John Watson and of Jochen Mass domiciled in Pennsylvania Avenue 44|it|bla bla bla|id2|en|We recommend the sites bbc.co.uk and cnn.com|it|Paolo Rossi and Giuseppina Verdi propongono i siti agriturismo.it dolomiti.it solocane.net' http://localhost:8080/anonymize_service.php
```
produces the response:
```bash
{
 "status": 0,
 "payload": [
     {
         "id": "id1", "side": 0,
         "annotations": [
             {
                 "type": "PER", 
                 "values": ["John Watson", "Jochen Mass"]
             }, 
             {
                 "type": "CREDITCARD", 
                 "values": ["5592-1234-5678-9876"]
             }, 
             {
                 "type": "ADDRESS", 
                 "values": ["Pennsylvania Avenue 44"]
             }
         ]
     }, 
     {
         "id": "id2", "side": 0,
         "annotations": [
             {
                 "type": "URL", 
                 "values": ["bbc.co.uk", "cnn.com"]
             }
         ]
     }, 
     {
         "id": "id2", "side": 1,
         "annotations": [
             {
                 "type": "PER", 
                 "values": ["Paolo Rossi", "Giuseppina Verdi"]
             }, 
             {
                 "type": "URL", 
                 "values": ["agriturismo.it", "dolomiti.it", "solocane.net"]
             }
         ]
     }
 ] 
}

```


## API specifications

[The API specs of the Anonymization Service are available here](https://drive.google.com/file/d/1QXJmeA0A3af3rwxaie1e6RaLJjFwyrbo/view?usp=sharing)

## Web GUI (Graphical User Interface)

To test the tool, a web graphical interface is made available in the Docker. It consists of a simple web page, where a text can be inserted and it is processed by the tool returning the list of the identified PIIs. The GUI allows the user to provide an email address to which the output of the tool is sent. 


## How to build the docker image

In order to build the docker image, the steps are:
1. download the archive [setup_for_docker_build_AS_image__v2.tar.gz](https://drive.google.com/file/d/15HWWIroU9reGi4nTf4e_ZCG7N_sE0tWc/view?usp=sharing)
2. extract the data from the archive
~~~
tar xvfz setup_for_docker_build_AS_image.tar.gz
~~~
3. run the script DO_build_AS_image.sh
~~~
bash DO_build_AS_image.sh
~~~


## Credits

FBK and Translated developed the Anonymization Service:
* FBK for the web service, interface with MBERT/DeepPavlov (NE processing), web GUI and integration;
* Translated for the Translated Anonymizer component (PII processing).


## Contacts

Please email cattoni AT fbk DOT eu




