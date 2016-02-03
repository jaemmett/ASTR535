all : push

push : 
	git add *
	git status
	git commit -m "-"
	git push origin master


