//
//  ServicesListResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/22/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

struct ServicesListResponse: Codable {
    let codRetorno: Int
    let message: JSONNull?
    let requestStatus: String
    let servicios: [Servicio]
}

struct Servicio: Codable {
    let id: Int
    let nombre: String
    let categorias: [Categoria]
    let active: Bool
}

struct Categoria: Codable {
    let id: Int
    let nombre: String
    let trabajos: [Categoria]?
    let descripcion: String
    let active: Bool
    let descripcionTitulo: String?
}

// MARK: Convenience initializers

extension ServicesListResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ServicesListResponse.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Servicio {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Servicio.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Categoria {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Categoria.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Servicio {

    var icon: UIImage? {
        if nombre == "peluqueria" {
            return UIImage(named: "peluqueria_blanco")
        }
        if nombre == "manicura/pedicura" {
            return UIImage(named: "manicura_blanco")
        }
        if nombre == "estetica" {
            return UIImage(named: "estetica_blanco")
        }
        if nombre == "masajes" {
            return UIImage(named: "aruba1")
        }
        if nombre == "nutricion" {
            return UIImage(named: "nutricion_blanco")
        }
        if nombre == "barberia" {
            return UIImage(named: "barberia_blanco")
        }
        return nil
    }

    var titleText: String? {
        if nombre == "peluqueria" {
            return "PELUQUERIA"
        }
        if nombre == "manicura/pedicura" {
            return "MANICURA/PEDICURA"
        }
        if nombre == "estetica" {
            return "ESTETICA"
        }
        if nombre == "masajes" {
            return "MASAJES"
        }
        if nombre == "nutricion" {
            return "NUTRICIÓN"
        }
        if nombre == "barberia" {
            return "BARBERIA"
        }
        return nil
    }

    var color: UIColor? {
        if nombre == "peluqueria" {
            return Colors.Peluqueria
        }
        if nombre == "manicura/pedicura" {
            return Colors.Manicura
        }
        if nombre == "estetica" {
            return Colors.Estetica
        }
        if nombre == "masajes" {
            return Colors.Masajes
        }
        if nombre == "nutricion" {
            return Colors.Nutricion
        }
        if nombre == "barberia" {
            return Colors.Barberia
        }
        return nil
    }
}
