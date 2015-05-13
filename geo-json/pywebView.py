import sys
from PyQt4.QtGui import QApplication
from PyQt4.QtCore import QUrl,Qt
from PyQt4.QtWebKit import QWebView


class Browser(QWebView):

    def __init__(self):
        QWebView.__init__(self)
        self.loadFinished.connect(self._result_available)

    def _result_available(self, ok):
        frame = self.page().mainFrame()
        frame.setScrollBarPolicy(Qt.Horizontal, Qt.ScrollBarAlwaysOff)
       # print unicode(frame.toHtml()).encode('utf-8')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    view = Browser()
    view.load(QUrl('geojson.html'))
    view.resize(800,600)
    view.setWindowTitle("Bhawanipatna-Map")
    #view.setWindowFlags(Qt.CustomizeWindowHint)
    #view.setWindowFlags(Qt.WindowMinimizeButtonHint)
    view.show()
    app.exec_()
