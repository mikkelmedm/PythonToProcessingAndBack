import argparse
import random
import time

from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import osc_server
from pythonosc import dispatcher

# Server og client skal have hver deres port

# Vi bruger client til at sende med:
client = udp_client.SimpleUDPClient("127.0.0.1", 1234)

# Funktionen har nu 4 parametre, da den modtager beskedID og de beskeder (her 3), der medfølger.
def sendvalues(unused_addr, message1, message2, message3):
# Der bruges format til at formatere tallene til string-værdier, istedet for objekter:

  print(unused_addr,"OSC ID'et")
  print(message1,"første message")
  print(message2,"anden message")
  print(message2,"tredje message")

  for x in range(10):
    client.send_message("/mousepressed", "{}".format(random.random()))
    time.sleep(1)
    if x == 9:
      break

def sendothervalues(unused_addr, message1):

  print(unused_addr,"OSC ID'et")
  print(message1,"første message")

  client.send_message("/keypressed", "vuf")

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip", default="127.0.0.1",
      help="The ip of the OSC server")
  parser.add_argument("--port", type=int, default=5005,
      help="The port the OSC server is listening on")
  args = parser.parse_args()

  dispatcher = dispatcher.Dispatcher()

  # Denne mapper en beskedID til en funktion.
  # Dvs. når en besked med et givent ID modtages, så køres den givne funktion:
  dispatcher.map("/miklo",sendvalues)
  dispatcher.map("/miklokey",sendothervalues)

  
  server = osc_server.ThreadingOSCUDPServer((args.ip, args.port), dispatcher)

  print("Serving on {}".format(server.server_address))
  server.serve_forever()