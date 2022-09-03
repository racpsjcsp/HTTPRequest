import Foundation

// Struct que será usado para enviar os dados no POST
struct ToDoResponseModel: Codable {
    var userId: Int
    var id: Int?
    var title: String
    var completed: Bool
}

// URL alvo
let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
guard let requestUrl = url else { fatalError() }

// Preparando o URL Request Object (HTTP Method: Post)
var request = URLRequest(url: requestUrl)
request.httpMethod = "POST"

// Adicionando HTTP Request Headers
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
// HTTP Request Parameters que serão enviandos no HTTP Request Body
let postString = "userId=300&title=TesteStructEMjson&completed=false"

// Criação de um objeto usando a struct acima
let newTodoItem = ToDoResponseModel(userId: 300, title: "Título do meu ToDo Aqui", completed: true)

// Convertendo o objeto (struct) em um JSON usando o JSONEncoder
let jsonData = try JSONEncoder().encode(newTodoItem)

request.httpBody = jsonData

// Execução do HTTP Request
let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    // Verificando por erro
    if let error = error {
        print("Error took place \(error)")
        return
    }
    
    // Data
    guard let data = data else { return }

    do {
        // Convertendo os dados (data) de JSON para STRUCT (ToDoResponseModel)
        let todoItemModel = try JSONDecoder().decode(ToDoResponseModel.self, from: data)
        print("response data: \(todoItemModel)")
        print("todoItemModel title: \(todoItemModel.title)")
        print("todoItemModel id: \(todoItemModel.id ?? 0)")
    } catch let jsonError {
        print(jsonError)
    }
    
    // Acessando o response para obter o(s) header(s) especificado(s)
    if let response = response as? HTTPURLResponse {
        print(response.value(forHTTPHeaderField: "Content-Type") ?? "header not found!")
    }
}
task.resume()


