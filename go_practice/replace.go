package main 

import (
    "fmt"
    "strings"
    "os"
    "path/filepath"
    "flag" 
    "sort" 
)

type ChgList struct {
    name  string
    count int
}

type ChgedFiles []ChgList

func (s ChgedFiles) Len() int {
    return len(s)
}

func (s ChgedFiles) Less(i, j int) bool {
    return s[i].count > s[j].count
}

func (s ChgedFiles) Swap(i, j int) {
    s[i], s[j] = s[j], s[i]
}

func getFilelist(path, arg string)(list ChgedFiles) {
		list = make(ChgedFiles,0,100)
    err := filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
            if ( f == nil ) {return err}
            if f.IsDir() {return nil}
            count := open_file(path, arg)
            if (count > 0){
            	list = append(list,ChgList{path, count})           
            }
            return nil
    })
    if err != nil {
            fmt.Printf("filepath.Walk() returned %v\n", err)
    }
return
}

func open_file(path, arg string)(count int){
		if(path != "replace.go"){
    fi, err := os.OpenFile(path, os.O_RDWR, 0777)
    if err != nil {
        fmt.Printf("Error: %v\n", err)
        return
    }
    defer fi.Close()
    finfo, _ := fi.Stat() //get the file size from file info
    data := make([]byte, finfo.Size())
    fi.Read(data) //load content into data
    sdata := string(data)
    count, sdata = search_string(arg, sdata)
    data = []byte(sdata)
    fi.Seek(0, 0)
    fi.Write([]byte(data))
    }
    return 
}

func search_string(rep, orig string)(cout int,r string){
		cout = strings.Count(orig,rep)
		if ( cout > 0 ) {
			r = strings.Replace(orig, rep, strings.ToUpper(rep), -1)
		}
		return
}

func main() {
		flag.Parse()
    str := flag.Arg(0)
    
    listed := getFilelist(".", str)
    sort.Sort(listed)
    fmt.Println("Changes		 File Name")
    
    for _, v := range listed {
    if(v.count != 0){
    		fmt.Println(v.count, "		", v.name)
    		}
    }
}