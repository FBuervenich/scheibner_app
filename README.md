# CMS-Simulation
## Scheibner m‐tec GmbH

## Introduction
This project is part of the evaluation of the course ‘Mobile Information Systems’, in the summer semester
2019, started at April 8th 2019. The result of this project counts for 50% of the total result of the
evaluation.
The project is carried out in groups of maximum 3 students.

See the documentation [here](https://github.com/FBuervenich/scheibner_app/blob/master/FinaleAbgabe/Doku.pdf)

## Context
Das Scheibner mega‐m.a.x‐System dient vorzugsweise zur Diagnose der Motorradrahmen nach Unfällen
(siehe http://www.scheibner.de/scheibner/de/102_zertifikat.php). Eine optionale Erweiterung CMS
(Chassis‐Maximising System) liefert jedoch wertvolle Informationen zur Geometrie des kompletten
Fahrwerks bezogen auf die Fahrbahnebene. Damit lassen sich die Fahreigenschaften insbesondere von
sportlichen und Rennmotorrädern optimieren (siehe
http://www.scheibner.de/scheibner/de/129_protokoll_und_simulation.php).
Die kombinierten mega‐m.a.x‐ und CMS‐Messergebnisse sieht der ausführende Betrieb jeweils am Ende
des Messvorganges. Eine Simulationssoftware erlaubt von dort aus relevante Fahrwerksparameter zu
verändern um auf diese Weise bereits am Rechner die Auswirkungen von Optimierungen zu erkennen
(siehe http://www.scheibner.de/scheibner/de/129_protokoll_und_simulation.php Bild unten).

Die geplante App soll nun diese Simulationssoftware in Verbindung mit den Messergebnissen des
jeweiligen Kundenmotorrades dem Eigner desselben zur Verfügung stellen. Sodann kann dieser auch
ohne die Hilfe bzw. die Kommunikation mit dem Betrieb eigene Optimierungen simulieren und so ein
besseres Verständnis für den Gesamtvorgang erlangen.
Dazu ist es notwendig, dass die App online auf die zuvor ermittelten Messergebnisse des ausführenden
Betriebes zugreifen kann. Zusätzlich sollten einzelne Simulationen des Kunden gespeichert werden
können.
In einem zweiten Schritt wäre ein direkter Zugriff der Kunden von Scheibner Limited auf die Datenbank
mit den Herstellervorgaben inkl. Die gespeicherten Bilder bilden eine sinnvolle Ergänzung der geplanten
Scheibner m‐tec GmbH‐App (Scheibner m‐tec GmbH ist die neue Firma als Nachfolgering der britischen
Scheibner Limited). Der entsprechende Datenzugriff mit Abfrage der Zugangsberechtigung und die für
mobile Medien optimierte Darstellung wären die zu lösenden Aufgaben.
## Project description
For this project, you develop a working prototype of the mobile application using Google Flutter, either
executable on an Android device or an iOS device. You may choose the target device (smart phone, tablet)
and layout (portrait, landscape) for the application based on the functionalities you will implement.
Requirements
1. A runnable prototype, demonstrated on a device of your choice, of the application
2. App icon
Dr. ir. Kris Cardinaels
3 
3. Launch screen
4. Main application to do a simulation based on the five data to be ‘entered’, giving the result of the
following parameters: Lenkkopfwinkel, Nachlauf, Offset, Schwingenwinkel and Radstand
5. Data entry of measurement data (Messergebnissen) from mega-m.a.x. through data exchange
(automatic download) or manual entry.
6. Local storing of resulting simulation data for later reference; notes to be added to the simulation
(CMS-Notizen)
7. Upload of simulation data to Scheibner-server
Options
1. Barcode scanning after mega-m.a.x. measurement to download results to app. Barcode generated
in web application?
2. Graphic data entry instead of text input fields
3. Graphic result instead of numbers only
Deadline and deliverables
 03.06.2019: Intermediate ‘coaching’ – individual group coaching about current status.
 01.07.2019: Project demonstration: starting at 10h15. 10 minutes of demonstration per group
(complete class is participating)
 Deliverables:
o Digital project document describing the mobile app (functionality, class diagram (UML),
user interface, configuration options,…)
o User test result: perform at least a test with 2 users and document the test with pictures
and an interview about the findings
o Zip-archive containing the application program code and assets
