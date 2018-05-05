#Libraries to be import
require 'typhoeus'
require 'link_header'
require 'json'

canvas_url = 'https://nwmissouridev.instructure.com/' # put full canvas test url eg: https://school.test.instructure.com
canvas_token = '10688~ajdR3EGek6l5O09BqDhKpgKo4ZW5wD0yWrNJcZOCx5HQoYti2jKAAM1DUDyyRbXO' # put canvas API token here
api_endpoint = '/api/v1/accounts/self/courses'

#User inputs to create the quizz
course_name = "GENERAL ZOOLOGY LAB"
quizz_detail = {
        "title" => "Test Quizz3",
        "description" => "Test Desc3",
        "type" => "practice_quiz",
        "time_limit" => 160
}


#Function to create the quizzes
def createQuizzes(canvas_url,canvas_token,course,quizz_detail)
    
    api_endpoint2 = 'api/v1/courses'
    id = course["id"]
    request_url2 = "#{canvas_url}#{api_endpoint2}/#{id}/quizzes"
    
    create_quizz = Typhoeus::Request.new(
        request_url2,    #we need a variable here because we need the api url to change
        method: :post,
        headers: { authorization: "Bearer #{canvas_token}"},
        params: {
            "quiz[title]" => quizz_detail["title"],
            "quiz[description]" => quizz_detail["description"],
            "quiz[quiz_type]" => quizz_detail["type"],
            "quiz[time_limit]" => quizz_detail["time_limit"] 
        })

    create_quizz.on_complete do |response|
        if response.code == 200
           puts "Quizz created successfully for Course id #{id}"
        else
            puts "Something went wrong! Response code was #{response.code}"
        end
    end

    create_quizz.run
end
#End create quizz function


#Variables initialisation
request_url = "#{canvas_url}#{api_endpoint}"
count = 0
more_data = true
course_found = false

while more_data   # while more_data is true keep looping through the data

    #puts request_url #helps demonstrate pagination
    get_courses = Typhoeus::Request.new(
        request_url,    #we need a variable here because we need the api url to change
        method: :get,
        headers: { authorization: "Bearer #{canvas_token}" }
        )
    get_courses.on_complete do |response|
        #get next link
            links = LinkHeader.parse(response.headers['link']).links
            next_link = links.find { |link| link['rel'] == 'next' } 
            request_url = next_link.href if next_link 
            if next_link && "#{response.body}" != "[]"
                more_data = true
            else
                more_data = false
            end
        #ends next link code
        if response.code == 200
            data = JSON.parse(response.body)
            data.each do |courses|
                count += 1
                if courses['name'] == course_name
                    more_data = false
                    course_found = true
                    createQuizzes(canvas_url,canvas_token,courses,quizz_detail)
                end
            end
        else
            puts "Something went wrong! Response code was #{response.code}"
        end
    end
    get_courses.run
end

#If no course for user provided input 
if !course_found
    puts "Course not found"
end

puts "Script done running"

