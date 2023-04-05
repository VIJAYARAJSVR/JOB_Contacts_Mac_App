//
//  ContentView.swift
//  JOB_Capture_Contacts
//
//  Created by Web_Dev on 4/5/23.
//

import SwiftUI

struct MainView: View {
    
    //    Company --->  Command + O
    
    //    Designation--->  Command + D
    
    //    Name--->  Command + N
    
    //    Email--->  Command + E
    
    //    Website--->  Command + T
    
    //    Phone--->  Command + P
    
    //    Save --->  Command + S
    
    //    Clear --->  Command + K
    
    
    
    @State var Company:String = ""
    @State var Designation:String = ""
    @State var Name:String = ""
    @State var Email:String = ""
    @State var Website:String = ""
    @State var Phone:String = ""
    
    
    
    @State var CaptureDate:String=""
    @State var CaptureTime:String=""
    
    @State var statusInfo = "Not Yet Saved"
    @State var status = SaveStatus.Failure
    
    enum SaveStatus:Error {
        case Success
        case Failure
    }
    
    func ClearAllState() {
        Company = ""
        Designation = ""
        Name = ""
        Email = ""
        Website = ""
        Phone = ""
        
//        statusInfo = ""
    }
    
    func EnableSaveButton() -> Bool {
        
        if((Company=="" && Name == "" ) && (Email=="" && Website=="" && Phone==""))
        {
            print("Required Fields are empty")
            return false
        }
        
        return true
    }
    
    func Get_Current_DateTime_forFileName() -> String {
        let dt = Date()
        let dateFormatter = DateFormatter()
        // Set Date/Time Style
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd_MM_YYYY"
        let currentDate = dateFormatter.string(from: dt)
        
        
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = dateFormatter.string(from: dt)

//         let AMPM = hrs >= 12 ? `PM` : `AM`;
//         hrs = (hrs - 12 * parseInt(hrs / 12));
//         hrs = hrs ? hrs : 12;
//         mnts = mnts < 10 ? `0` + mnts : mnts;
        
        let arrTime = time.components(separatedBy: ":")
        var hrs = Int(arrTime[0])!
        let mnts = Int(arrTime[1])!
        let sec = Int(arrTime[2])!
        
        let AMPM = (hrs >= 12) ? "PM": "AM";
        hrs = hrs - 12 * (hrs / 12)
        hrs = (hrs != 0) ? hrs : 12
        
        let minutes = (mnts < 10) ? "0" + String(mnts) : String(mnts)
        
        //Applied_JOB_info 28_01_2023  2_24 AM  45 sec
        
        let current_DateTime = currentDate+"  "+String(hrs)+"_"+minutes+" "+AMPM+"  "+String(sec)+" sec"
        
        return current_DateTime
        
    }
    
    func Save_as_JSON() {
        
        if Email == "" && Website == "" && Phone == ""
        {
            statusInfo = "Please fill Email/Website/Phone Field"
            return
        }

        if Company == "" && Name == ""
        {
            statusInfo = "Please fill Company/Name Field"
            return
        }
        

        
        Company =   (Company == "") ? "not Found" : Company
        Name =   (Name == "") ? "not Found" : Name
        Email =   (Email == "") ? "not Found" : Email
        Website =   (Website == "") ? "not Found" : Website
        Phone =   (Phone == "") ? "not Found" : Phone
        Designation =   (Designation == "") ? "not Found" : Designation
        
        
        
        //Applied_JOB_info 28_01_2023  2_24 AM  45 sec
        let filename = "Contacts "+Get_Current_DateTime_forFileName();

        let dt = Date()
        let dateFormatter = DateFormatter()
        //"AppliedDate": "28/01/2023",
        //"AppliedTime": "2:24:45",
        dateFormatter.dateFormat = "dd/MM/YYYY"
        CaptureDate=dateFormatter.string(from: dt)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        CaptureTime=dateFormatter.string(from: dt)
        
        let record_Created = CaptureDate+" "+CaptureTime


        //JSON Object
        let JobDetail_Object = JobContact(Company: Company, Designation: Designation, Name: Name,Email: Email,Website: Website,Phone: Phone,
                                          recordcreated: record_Created)
        
        
    
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted , .sortedKeys , .withoutEscapingSlashes]
        
        //Converting JSON Object to JSON DATA
        let jsonData = (try? encoder.encode(JobDetail_Object))!
        
    
        do {
            _ = try save_From_JSON_Data(data: jsonData, toFilename: filename)
        }
        catch let error {
           print("error is \(error)")
        }
        
        getDocumentsDirectory1()
    }
    
    func save_From_JSON_Data(data: Data, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            try data.write(to: fileURL, options: [.atomicWrite])
            statusInfo = "Saved Successfully"
            ClearAllState()
            return true
        }
        return false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
        
        return documentsDirectory
    }
    
    func getDocumentsDirectory1() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
        

    }
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                let kequi:KeyEquivalent = "o"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Company,kkey:"O")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                Text("Company")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                
                
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Company", text: $Company).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                let kequi:KeyEquivalent = "d"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Designation,kkey:"D")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Designation")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Designation", text: $Designation).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                
                let kequi:KeyEquivalent = "n"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Name,kkey:"N")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                Text("Name")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                
                
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Name", text: $Name).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                let kequi:KeyEquivalent = "e"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Email,kkey:"E")


                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Email")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Email", text: $Email).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            

            
            HStack {
                let kequi:KeyEquivalent = "t"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Website,kkey:"T")

                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Website")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Website", text: $Website).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            HStack {
                let kequi:KeyEquivalent = "p"
                PasteButtonView(keyshortcut: kequi,stateVariable:$Phone,kkey:"P")
                Spacer()
                    .frame(width: 10)
                    .clipped()
                Text("Phone")
                    .frame(width: 150, alignment: .leading)
                    .clipped()
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(width: 10)
                    .clipped()
                
                TextField("Phone", text: $Phone).textFieldStyle(CustomTextFieldStyle())
                Spacer()
            }
            .padding()
            
            Text(statusInfo)
                .padding(.vertical, 12)
                .padding(.horizontal, 34)
                .foregroundColor(.yellow)
                .padding(.bottom, 0)
                .font(.largeTitle)
            
            HStack {
                Spacer()
                Button("Save") {
                    Save_as_JSON()
                }
                    .keyboardShortcut("s", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                    .disabled((Email=="" && Website=="" && Phone==""))
                Spacer()
                    .frame(width: 40)
                    .clipped()
                
                
                Button("Clear") {
                    ClearAllState()
                   
                }    .keyboardShortcut("k", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                
                Spacer()
            }
            
            .padding()
            .padding(.bottom, 40)
            
            .clipped()
        }
        .padding()
        .clipped()
        .background(Color(.sRGB, red: 40/255, green: 44/255, blue: 51/255))
    }
    
    
}



struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height:35)
            .clipped()
            .font(.largeTitle)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color("ClrTxtField"), Color("ClrTxtField")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.black)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
