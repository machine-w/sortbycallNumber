#encoding: UTF-8
require "./callNumber.rb"
require "spreadsheet" 
Spreadsheet.client_encoding = "UTF-8"
source = Spreadsheet.open 'example.xls'
target= Spreadsheet::Workbook.new  
sheet = source.worksheet 0  
sheet2 = target.create_worksheet :name => 'target'
call_list = []
# call_num={}
sheet.each do |row|
	# p row[0].strip
	call_num=Hash.new
	call_num['cn']=CallNumber.new(row[0].strip)
	call_num['tm']= row[1]
	call_num['wz']= row[2]
	call_list.push(call_num)
end 
call_list.sort! { |a,b| a['cn'] <=> b['cn'] }
i=0
call_list.each do |e|  
	sheet2.row(i)[0]=e['cn'].to_s
	sheet2.row(i)[1]=e['tm'].to_s
	sheet2.row(i)[2]=e['wz'].to_s
	i+=1
end
target.write 'target.xls' 
