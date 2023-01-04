class Workpackage:
    all_wbs = []
    sum_duration = 0
    cnt_ws = 0
    def __init__(self, name):
        Workpackage.all_wbs.append(self)
        self.duration = 0
        Workpackage.cnt_ws += 1
        self.status = 'Init'
        self.name = name
    def GetStatus(self):
        return(self.status)
    def GetDuration(self):
        return(self.duration)
    def SetDuration(self, duration):
        self.duration = duration
        Workpackage.sum_duration += duration
    def SetStatus(self, status):
        self.status = status
    def GetName(self):
        return(self.name)
    def SetName(self, name):
        self.name = name
    def PrintAll(self):
        print("WBS: " + self.name)
        print(f"Mein Status ist {self.status}")
        print(f"Mein Zeitaufwand ist noch {self.GetDuration()} Stunden")