##Should ONLY have client necessary data. This means unit action queue and the troop name. No images or anything needs to be sent, the client already has all that stuff downloaded!
##Also, this only needs to be sent when the planning stage is about to start, at the timer end, or when both players are ready
class_name ClientData
extends Resource

var action_queue: Array[Dictionary]
var troop_name: TroopData.NAME
