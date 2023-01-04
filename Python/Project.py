from Workpackage import Workpackage

class project:
    def __init__(self, name):
        self.all_wbs = []
        self.duration = 0
        self.wbs_count = len(self.all_wbs)
        self.name = name
    def GetName(self):
        return self.name
    def GetWbsCnt(self):
        return len(self.all_wbs)
    def AddWbs(self, wbs):
        self.all_wbs.append(wbs)
    def GetDuration(self):
        self.duration = 0
        for i in self.all_wbs:
            self.duration += i.GetDuration()
        return self.duration
    def PrintAll(self):
        for i in self.all_wbs:
            i.PrintAll()