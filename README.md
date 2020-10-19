# TM-Anonymizer
This repository contains the software to run the Translation Memory anonymizer service developed during the CEF Data MarketPlace project. 

The goal of the tool is to protect private information possibly contained in TMs uploaded to the Marketplace. This is obtained by detecting Personally Identifiable Information (PII) in the source and target-language sides of a translation memory. 

A PII is any data that could potentially identify a specific individual. The identified PIIs by the tool are: 

person names, emails, URLs, addresses, phone numbers, credit card numbers, driver’s license numbers, identity card numbers, passport numbers, social security numbers, license plate numbers.


## The tool
The tool includes two different libraries to extract the required PIIs from the source and target language texts. 

The person names are extracted using the [DeepPavlov NER tool] (https://docs.deeppavlov.ai/en/master/features/models/ner.html). It is a hybrid model based on Multilingual BERT adapted for the named entity recognition task. Among all the possible types of entities, our tool selects only the persons. 

All the other PIIs are obtained by an in-house software based on regular expressions and language-specific knowledge and patterns.

The tool is able to extract PIIs in 5 languages: English, Czech, German, Italian, Latvian. More languages will be added during the project.


## Installation and Usage

The Docker image of the code is available here  (around 3GB) 


Once the Docker image has been downloaded, it has to be added to your docker environment
```bash
$ docker load < image.anonymization_service.tar.gz
```

To start the service, run the following command:
```bash
$ docker run --rm -it --publish 8080:8080 anonymization_service
```

The process prints several information, when it prints the message
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
curl -X POST -F units='id1|en|credit cards 1234-XXXX-YYYY of mr. John Watson and of Jochen Mass|it|bla bla bla|id2|en|We recommend the sites bbc.co.uk and cnn.com|it|Paolo Rossi and Giuseppina Verdi propongono i siti agriturismo.it dolomiti.it solocane.net' http://localhost:8080/anonymize_service.php
```
produces the response:
```bash
{"status": 0,
 "payload":
   [{"id": "id1", "side": 0,
     "annotations":
       [{"type": "CREDITCARD",
         "values":
           ["1234-XXXX-YYYY", "6666-XXXX-YYYY", "7890-XXXX-YYYY"]
        },
        {"type": "PER",
         "values":
           ["John Watson", "Jochen Mass"]
        }
       ]
    },
    {"id": "id2", "side": 0,
     "annotations":
       [{"type": "URL",
         "values":
           [ "bbc.co.uk", "cnn.com"]
        }]
    },
    {"id": "id2", "side": 1,
     "annotations":
       [{"type": "URL",
         "values":
           [ "agriturismo.it", "dolomiti.it", "solocane.net"]
        },
        {"type": "PER",
         "values":
           [ "Paolo Rossi", "Giuseppina Verdi"]
        }
       ]
    }]
}
```


## API

[The API specs of the Anonymization Service are available here](https://drive.google.com/file/d/1QXJmeA0A3af3rwxaie1e6RaLJjFwyrbo/view?usp=sharing)



## Credits

FBK and Translated developed the Anonymization Service:
* FBK for the web service, interface with MBERT/DeepPavlov (NE processing) and integration;
* Translated for the Translated Anonymizer component (PII processing).


## Contacts

Please email cattoni AT fbk DOT eu


Info: v1.0, 2020/10/14



