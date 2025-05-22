import sys
import smtpdlib
from email.mine.text import MIMEText 

def send_mail (subject, body):
    to_email = "Destinataire@gmail.com" # Remplacez par l'adresse e-mail de votre destinataire 
    from_email = "VotreEmail@gmail.com" # Remplacez par votre adresse Gmail 
    smtp_server = "smtp.gmail.com" #serveur smtp de Gmail
    smtp_port = 587 #changer en fonction de votre serveur
    smtp_user = "VotreEmail@gmail.com" # votre identifiant Gmail/adresse gmail 
    smtp_password = "votre_mot_de_passe"

    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = from_email
    msg['To'] = to_email

    with smtpdlib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(smtp_user, smtp_password)
        server.sendmail(from_email, [to_email], msg.as_string())
    print("Mail envoyé à", to_email)

    if __name__ == "__main__":
        subject = sys.argv[1]
        body = sys.argv[2]
        send_mail(subject, body)