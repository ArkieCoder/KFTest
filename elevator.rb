
class ElevatorSimulation
    def initialize(elevator_count, floor_count) 
        @elevator_count = elevator_count
        @floor_count = floor_count
        @elevators = Array.new
        elevator_count.times do
            @elevators << Elevator.new(@floor_count)
        end
    end

    def request(from_floor)

    end
end

class Elevator
    def initialize(floor_count) 
        @floor_count = floor_count
        @trip_count = 0
        @floors_passed = 0
        @current_floor = 1
        @occupied = false
    end

    def request(from_floor)
    end
end