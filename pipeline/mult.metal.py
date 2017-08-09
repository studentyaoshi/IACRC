def getRealSubSet(fromList,toList):
    if(len(fromList) <= 1):
        return
    for id in range(len(fromList)):
        arr = [i for i in fromList if i != fromList[id]]
        getRealSubSet(arr,toList)
        #print arr
        if(toList.count(arr) == 0):
            toList.append(arr)
li = []
getRealSubSet(['1627','2286','45360','46141','whi.aa','whi.his'],li)
li.sort()
a=open('metal.files','wt')
for i in li:
	if len(i)>=2:
		for w in i:
			a.write(w+',')
	else:
		continue
	a.write('\n')
a.close()
